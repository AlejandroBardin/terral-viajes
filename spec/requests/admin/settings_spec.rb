require 'rails_helper'

RSpec.describe "Admin::Settings", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/settings/index"
      expect(response).to have_http_status(:success)
    end
  end
end
