class Admin::SettingsController < Admin::BaseController
  def index
    @settings = Setting.all
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
