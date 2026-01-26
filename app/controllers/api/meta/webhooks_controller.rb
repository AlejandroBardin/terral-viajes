module Api
  module Meta
    class WebhooksController < ApplicationController
      allow_unauthenticated_access
      skip_before_action :verify_authenticity_token
      before_action :verify_signature, only: [ :handle ]

      def handle
        if request.get?
          verify
        elsif request.post?
          leadgen
        else
          head :method_not_allowed
        end
      end

      # GET /api/meta/webhooks/verify
      def verify
        mode = params["hub.mode"]
        token = params["hub.verify_token"]
        challenge = params["hub.challenge"]

        if mode == "subscribe" && token == Rails.application.credentials.dig(:meta, :verify_token)
          render plain: challenge, status: :ok
        else
          render plain: "Forbidden", status: :forbidden
        end
      end

      # POST /api/meta/webhooks/leadgen
      def leadgen
        # Iterate over entries (Meta sends batch updates)
        changes = params[:entry] || []

        changes.each do |entry|
          entry[:changes]&.each do |change|
            # We only care about leadgen field
            next unless change[:field] == "leadgen"

            value = change[:value]

            # Delegate processing to background job to respond quickly (< 5s)
            ::Meta::LeadEnrichmentJob.perform_later(value.to_unsafe_h)
            Rails.logger.info "Meta Lead Queued: #{value['leadgen_id']}"
          end
        end

        head :ok
      end

      private

      def verify_signature
        return if request.get? || request.head? # Verification doesn't use HMAC in this way

        signature = request.headers["X-Hub-Signature-256"]
        return head :forbidden unless signature

        # Extract 'sha256=' prefix
        _, signature_hash = signature.split("=")

        body = request.body.read
        app_secret = Rails.application.credentials.dig(:meta, :app_secret)

        expected_hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), app_secret, body)

        unless ActiveSupport::SecurityUtils.secure_compare(signature_hash, expected_hash)
          Rails.logger.warn "Meta Webhook Signature Mismatch!"
          head :forbidden
        end
      end
    end
  end
end
