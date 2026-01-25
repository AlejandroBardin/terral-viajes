require "faraday"

module Meta
  class GraphClient
    GRAPH_ENDPOINT = "https://graph.facebook.com/v19.0"

    def initialize(access_token)
      @access_token = access_token
    end

    def get_lead_details(leadgen_id)
      response = ::Faraday.get("#{GRAPH_ENDPOINT}/#{leadgen_id}", {
        access_token: @access_token,
        fields: "created_time,id,ad_id,form_id,field_data,platform,is_organic"
      })

      handle_response(response)
    end

    def get_ad(ad_id)
      return nil unless ad_id.present? && ad_id.to_s != "0"

      response = ::Faraday.get("#{GRAPH_ENDPOINT}/#{ad_id}", {
        access_token: @access_token,
        fields: "creative"
      })

      handle_response(response)
    end

    def get_ad_creative(creative_id)
      response = ::Faraday.get("#{GRAPH_ENDPOINT}/#{creative_id}", {
        access_token: @access_token,
        fields: "name,title,body,image_url,thumbnail_url,object_story_spec,asset_feed_spec"
      })

      handle_response(response)
    end

    private

    def handle_response(response)
      data = JSON.parse(response.body)

      if data["error"]
        Rails.logger.error("Meta Graph Error: #{data['error']['message']}")
        raise "Meta Graph Error: #{data['error']['message']}"
      end

      data
    end
  end
end
