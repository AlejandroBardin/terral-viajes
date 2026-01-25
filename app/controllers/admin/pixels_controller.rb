class Admin::PixelsController < Admin::BaseController
  layout false

  def show
    @pixel_id = Setting.find_by(key: "facebook_pixel")&.value
    @access_token = Setting.find_by(key: "facebook_access_token")&.value
  end

  def update
    Setting.find_or_create_by(key: "facebook_pixel").update(value: params[:pixel_id])
    if params[:access_token].present?
      Setting.find_or_create_by(key: "facebook_access_token").update(value: params[:access_token])
    end

    redirect_to admin_pixel_path, notice: "Configuración actualizada."
  end
end
