class Admin::SettingsController < Admin::BaseController
  def index
    @meta_connection = MetaPageConnection.active.first
  end

  def disconnect_meta
    MetaPageConnection.active.update_all(is_active: false)
    redirect_to admin_settings_path, notice: "Facebook Page disconnected."
  end
end
