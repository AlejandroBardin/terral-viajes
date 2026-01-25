class Admin::SettingsController < Admin::BaseController
  def index
    @marketing_settings = Setting.where(key: [ "facebook_pixel", "google_analytics_id" ])
    @general_settings = Setting.where.not(key: [ "facebook_pixel", "google_analytics_id" ])
  end

  def update
    @setting = Setting.find(params[:id])
    if @setting.update(setting_params)
      redirect_to admin_settings_path, notice: "Configuración actualizada."
    else
      redirect_to admin_settings_path, alert: "Error al actualizar."
    end
  end

  private

  def setting_params
    params.require(:setting).permit(:value)
  end
end
