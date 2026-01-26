class ChatwootClient
  include HTTParty
  base_uri ENV.fetch("CHATWOOT_INSTALLATION_URL", "https://app.chatwoot.com")

  def initialize
    @token = ENV["CHATWOOT_API_ACCESS_TOKEN"]
    @account_id = ENV.fetch("CHATWOOT_ACCOUNT_ID", "1")
    @inbox_id = ENV["CHATWOOT_INBOX_ID"]
  end

  def find_contact_by_email(email)
    response = self.class.get(
      "/api/v1/accounts/#{@account_id}/contacts/search",
      query: { q: email },
      headers: headers
    )

    return nil unless response.success?

    contacts = response.parsed_response["payload"]
    contacts.find { |c| c["email"] == email }
  end

  def create_contact(payload)
    self.class.post(
      "/api/v1/accounts/#{@account_id}/contacts",
      body: payload.to_json,
      headers: headers
    )
  end

  def create_conversation(contact_id, additional_attributes = {})
    payload = {
      source_id: contact_id,
      inbox_id: @inbox_id,
      status: "open"
    }.merge(additional_attributes)

    self.class.post(
      "/api/v1/accounts/#{@account_id}/conversations",
      body: payload.to_json,
      headers: headers
    )
  end

  def update_contact(contact_id, attributes)
    self.class.put(
      "/api/v1/accounts/#{@account_id}/contacts/#{contact_id}",
      body: { custom_attributes: attributes }.to_json,
      headers: headers
    )
  end

  private

  def headers
    {
      "Content-Type" => "application/json",
      "api_access_token" => @token
    }
  end
end
