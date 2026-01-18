module Admin::SettingsHelper
  def setting_label(key)
    labels = {
      "whatsapp_number" => "Número de WhatsApp",
      "facebook_pixel" => "Facebook Pixel ID",
      "hero_title" => "Título del Hero",
      "hero_subtitle" => "Subtítulo del Hero"
    }
    labels[key] || key.humanize
  end
end
