module GtagHelper
  def google_analytics_tag
    ga_id = ENV.fetch("GOOGLE_ANALYTICS_ID", nil) || Setting.find_by(key: "google_analytics_id")&.value
    return unless ga_id.present?

    content_tag(:script, nil, async: true, src: "https://www.googletagmanager.com/gtag/js?id=#{ga_id}") +
      content_tag(:script) do
        <<~JAVASCRIPT.html_safe
          window.dataLayer = window.dataLayer || [];
          function gtag(){dataLayer.push(arguments);}
          gtag('js', new Date());
          gtag('config', '#{ga_id}');
        JAVASCRIPT
      end
  end

  def gtag_event(event_name, params = {})
    return unless Rails.env.production? || Rails.env.staging?

    content_tag(:script) do
      "gtag('event', '#{event_name}', #{params.to_json});".html_safe
    end
  end
end
