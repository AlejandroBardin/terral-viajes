class ChatwootIntegrationJob < ApplicationJob
  queue_as :default

  def perform(lead_id)
    lead = Lead.find_by(id: lead_id)
    return unless lead

    client = ChatwootClient.new

    # 1. Find or Create Contact
    contact = client.find_contact_by_email(lead.email)

    unless contact
      response = client.create_contact({
        name: lead.full_name,
        email: lead.email,
        phone_number: lead.phone_number,
        custom_attributes: {
          meta_leadgen_id: lead.meta_leadgen_id,
          platform: lead.platform,
          ad_headline: lead.ad_headline
        }
      })

      if response.success?
        contact = response.parsed_response["payload"]["contact"]
      else
        Rails.logger.error "❌ Failed to create Chatwoot contact for Lead #{lead.id}: #{response.body}"
        return
      end
    end

    # 2. Create Conversation
    response = client.create_conversation(contact["id"], {
      additional_attributes: {
        campaign_name: lead.ad_headline,
        source: lead.platform
      }
    })

    if response.success?
      conversation = response.parsed_response

      # 3. Update Lead
      lead.update_columns(
        chatwoot_contact_id: contact["id"],
        chatwoot_conversation_id: conversation["id"]
      )

      Rails.logger.info "✅ Linked Lead #{lead.id} to Chatwoot Conversation ##{conversation['id']}"
    else
      Rails.logger.error "❌ Failed to create Chatwoot conversation for Lead #{lead.id}: #{response.body}"
    end
  end
end
