module Meta
  class LeadEnrichmentJob < ApplicationJob
    queue_as :default

    def perform(lead_data)
      Rails.logger.info "Processing Meta Lead: #{lead_data.inspect}"

      leadgen_id = lead_data["leadgen_id"]
      page_id = lead_data["page_id"]
      ad_id = lead_data["ad_id"]

      # 1. Find the Page Connection
      page_connection = MetaPageConnection.find_by(page_id: page_id)

      unless page_connection
        Rails.logger.error "MetaPageConnection not found for page_id: #{page_id}"
        return
      end

      # 2. Initialize Graph Client
      # Assuming 'encrypted_access_token' is handled by Rails encryption
      client = Meta::GraphClient.new(page_connection.encrypted_access_token)

      # 3. Fetch Lead Details
      # If it's a test lead (ad_id == "0"), we might get a 404 for leadgen_id from real Graph API
      # unless we are using a test user/page token.
      # For now, let's wrap in rescue
      begin
        lead_details = client.get_lead_details(leadgen_id)
        Rails.logger.info "Lead Details: #{lead_details.inspect}"
      rescue => e
        Rails.logger.warn "Failed to fetch lead details: #{e.message}. Might be a test lead."
      end

      # 4. Fetch Ad Creative if applicable
      if ad_id.present? && ad_id != "0"
        begin
          ad = client.get_ad(ad_id)
          if ad && ad["creative"]
            creative_id = ad["creative"]["id"]
            creative = client.get_ad_creative(creative_id)
            Rails.logger.info "Ad Creative: #{creative.inspect}"
          end
        rescue => e
           Rails.logger.error "Failed to fetch ad details: #{e.message}"
        end
      else
         Rails.logger.info "Test Lead or Organic (ad_id is 0 or missing). Skipping Ad Creative fetch."
      end

      # 5. Create or Update Lead
      lead = Lead.find_or_initialize_by(meta_leadgen_id: leadgen_id)

      lead.assign_attributes(
        # Meta IDs
        meta_page_id: page_id,
        meta_form_id: lead_data["form_id"],
        meta_ad_id: ad_id,

        # Source
        platform: lead_details&.dig("platform"),
        is_organic: lead_details&.dig("is_organic") || (ad_id == "0"),

        # We need to parse field_data for PII (dummy for now as field names vary)
        # full_name: extract_field(lead_details, "full_name"),
        # email: extract_field(lead_details, "email"),

        # Ad Context
        ad_headline: creative&.dig("title"),
        ad_body: creative&.dig("body"),

        status: :new_lead,
        raw_data: lead_details
      )

      if lead.save
        Rails.logger.info "Lead #{lead.id} saved successfully!"

        # 6. Attach Image (Phase 4 Logic)
        image_url = creative&.dig("image_url") || creative&.dig("thumbnail_url")

        if image_url.present? && !lead.ad_creative_snapshot.attached?
          begin
            downloaded_image = URI.open(image_url)
            lead.ad_creative_snapshot.attach(io: downloaded_image, filename: "ad_#{ad_id}.jpg")
             Rails.logger.info "Ad Image attached!"
          rescue => e
            Rails.logger.error "Failed to attach image: #{e.message}"
          end
        end
      else
        Rails.logger.error "Failed to save lead: #{lead.errors.full_messages}"
      end
    end
  end
end
