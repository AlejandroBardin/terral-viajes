module Admin
  class LeadsController < ApplicationController
    layout "admin"

    def index
      @leads = Lead.recent.with_attached_ad_creative_snapshot

      # Basic Search/Filter placeholder
      if params[:platform].present?
        @leads = @leads.where(platform: params[:platform])
      end

      if params[:status].present?
        @leads = @leads.where(status: params[:status])
      end
    end

    def show
      @lead = Lead.find(params[:id])

      respond_to do |format|
        format.html { render partial: "drawer", locals: { lead: @lead } }
      end
    end
  end
end
