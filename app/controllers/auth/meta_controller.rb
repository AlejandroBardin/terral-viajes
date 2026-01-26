require "faraday"

module Auth
  class MetaController < ApplicationController
    # Skip verify_authenticity_token for callback if needed, but usually GET is fine

    def callback
      auth_code = params[:code]

      if params[:error]
        redirect_to admin_dashboard_path, alert: "Meta Auth Error: #{params[:error_description]}"
        return
      end

      # 1. Exchange Code for User Token (Short-lived)
      # Note: Usually this is done via JS SDK, but if implementing manual flow:
      token_manager = Meta::TokenManager.new

      # Assuming we get a short-lived token from client-side SDK or exchange code here
      # For server-side flow, we need to exchange code for token first
      # But for simplicity, we'll assume the client sends the Short-Lived Token
      # OR we implement the code exchange here.

      # If using standard Client-Side OAuth (FB SDK), the frontend sends the accessToken.
      # If using Server-Side Manual Flow, we exchange 'code'.

      # Let's assume we implement the Code Exchange for robustness
      short_lived_token = exchange_code_for_token(auth_code)

      # 2. Exchange for Long-Lived User Token
      long_lived_data = token_manager.exchange_user_token(short_lived_token)
      long_lived_token = long_lived_data[:access_token]

      # 3. Get Pages
      @pages = token_manager.get_managed_pages(long_lived_token)

      # Render view to select page
      # We'll store the long_lived_token in session temporarily
      session[:meta_long_lived_token] = long_lived_token

      render :select_page
    rescue => e
      redirect_to admin_dashboard_path, alert: "Error connecting Meta: #{e.message}"
    end

    def save_page
      long_lived_token = session[:meta_long_lived_token]
      page_id = params[:page_id]

      return redirect_to admin_dashboard_path, alert: "Session expired" unless long_lived_token

      token_manager = Meta::TokenManager.new

      # 4. Get Permanent Page Token
      page_data = token_manager.get_page_token(long_lived_token, page_id)

      # 5. Save to DB
      connection = MetaPageConnection.find_or_initialize_by(page_id: page_id)
      connection.update!(
        page_name: page_data[:page_name],
        encrypted_access_token: page_data[:access_token],
        is_active: true
        # user_id: current_user.id # If you have auth
      )

      # 6. Subscribe to Webhooks
      token_manager.subscribe_page_to_webhooks(page_id, page_data[:access_token])

      session.delete(:meta_long_lived_token)
      redirect_to admin_dashboard_path, notice: "Connected to #{page_data[:page_name]} successfully!"
    end

    private

    def exchange_code_for_token(code)
      response = ::Faraday.get("https://graph.facebook.com/v19.0/oauth/access_token", {
        client_id: Rails.application.credentials.dig(:meta, :app_id),
        client_secret: Rails.application.credentials.dig(:meta, :app_secret),
        redirect_uri: auth_meta_callback_url,
        code: code
      })

      JSON.parse(response.body)["access_token"]
    end
  end
end
