module Meta
  class CapiConversionJob < ApplicationJob
    queue_as :default

    PIXEL_ID = ENV["META_PIXEL_ID"] || "PLACEHOLDER_PIXEL_ID"
    ACCESS_TOKEN = ENV["META_ACCESS_TOKEN"] # Or fetch via TokenManager if system user based

    def perform(lead_id)
      lead = Lead.find_by(id: lead_id)
      return unless lead

      # Payload construction
      payload = {
        data: [
          {
            event_name: "Purchase",
            event_time: Time.now.to_i,
            action_source: "system_generated",
            user_data: {
              lead_id: lead.meta_leadgen_id,
              em: [ Digest::SHA256.hexdigest(lead.email.to_s.downcase.strip) ],
              ph: [ Digest::SHA256.hexdigest(lead.phone_number.to_s.gsub(/[^0-9]/, "")) ]
            },
            custom_data: {
              value: 100.0, # Placeholder value or dynamic if available
              currency: "USD"
            },
            event_id: "purchase_#{lead.id}_#{lead.updated_at.to_i}" # Dedup key
          }
        ]
      }

      # Send to Meta
      response = HTTParty.post(
        "https://graph.facebook.com/v19.0/#{PIXEL_ID}/events",
        body: payload.to_json,
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{fetch_access_token}"
        }
      )

      if response.success?
        Rails.logger.info "✅ CAPI Event Sent for Lead #{lead.id}: #{response.body}"
      else
        Rails.logger.error "❌ CAPI Error for Lead #{lead.id}: #{response.body}"
        # retry_job wait: 5.minutes if response.code >= 500
      end
    end

    private

    def fetch_access_token
      # In real scenario, use global page token or system user token
      # For now using the simplest approach or TokenManager
      # Meta::TokenManager.get_system_token
      ENV["META_ACCESS_TOKEN"]
    end
  end
end
