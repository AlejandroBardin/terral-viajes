require "faraday"

module Meta
  class TokenManager
    OAUTH_ENDPOINT = "https://graph.facebook.com/oauth/access_token"
    GRAPH_ENDPOINT = "https://graph.facebook.com/v19.0"

    def initialize(app_id: nil, app_secret: nil)
      @app_id = app_id || Rails.application.credentials.dig(:meta, :app_id)
      @app_secret = app_secret || Rails.application.credentials.dig(:meta, :app_secret)
    end

    # Step 1: Exchange short-lived User Token for Long-Lived User Token (60 days)
    def exchange_user_token(short_lived_token)
      response = ::Faraday.get(OAUTH_ENDPOINT, {
        grant_type: "fb_exchange_token",
        client_id: @app_id,
        client_secret: @app_secret,
        fb_exchange_token: short_lived_token
      })

      data = JSON.parse(response.body)

      if data["error"]
        raise "Meta OAuth Error: #{data['error']['message']}"
      end

      {
        access_token: data["access_token"],
        expires_in: data["expires_in"],
        token_type: "long_lived_user"
      }
    end

    # Step 2: Derive permanent Page Access Token from Long-Lived User Token
    def get_page_token(long_lived_user_token, page_id)
      response = ::Faraday.get("#{GRAPH_ENDPOINT}/me/accounts", {
        access_token: long_lived_user_token,
        fields: "id,name,access_token,picture"
      })

      data = JSON.parse(response.body)

      if data["error"]
        raise "Meta Graph Error: #{data['error']['message']}"
      end

      pages = data["data"]
      page = pages.find { |p| p["id"] == page_id.to_s }

      raise "Page #{page_id} not found or user lacks Admin role" unless page

      {
        access_token: page["access_token"], # This token DOES NOT expire for Page
        page_id: page["id"],
        page_name: page["name"],
        page_picture: page.dig("picture", "data", "url")
      }
    end

    # Step 3: Programmatically subscribe Page to webhooks
    def subscribe_page_to_webhooks(page_id, page_access_token)
      response = ::Faraday.post("#{GRAPH_ENDPOINT}/#{page_id}/subscribed_apps", {
        subscribed_fields: "leadgen",
        access_token: page_access_token
      })

      data = JSON.parse(response.body)

      data["success"] == true
    end

    # Helper: Get list of pages user manages (for selection UI)
    def get_managed_pages(user_access_token)
      # Debug: Log User Identity & Permissions
      user_debug = ::Faraday.get("#{GRAPH_ENDPOINT}/me", {
        access_token: user_access_token,
        fields: "id,name,permissions"
      })
      Rails.logger.info "Meta Auth User & Permissions: #{user_debug.body}"

      response = ::Faraday.get("#{GRAPH_ENDPOINT}/me/accounts", {
        access_token: user_access_token,
        fields: "id,name,access_token,picture,tasks"
      })

      data = JSON.parse(response.body)

      Rails.logger.info "Meta API Response (Pages): #{data.inspect}"

      return [] if data["error"]

      # Relax filtering for debugging
      data["data"]
      # .select { |p| p["tasks"].include?("ADVERTISE") || p["tasks"].include?("MANAGE") }
    end
  end
end
