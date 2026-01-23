module FacebookPixelHelper
  def facebook_pixel_tag
    # Intentar obtener desde Settings (gema config) primero, luego desde Setting (modelo)
    pixel_id = Settings.facebook_pixel.id.presence || Setting.find_by(key: "facebook_pixel")&.value
    return unless pixel_id.present?

    content_tag(:script) do
      <<~JAVASCRIPT.html_safe
        !function(f,b,e,v,n,t,s)
        {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
        n.callMethod.apply(n,arguments):n.queue.push(arguments)};
        if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
        n.queue=[];t=b.createElement(e);t.async=!0;
        t.src=v;s=b.getElementsByTagName(e)[0];
        s.parentNode.insertBefore(t,s)}(window, document,'script',
        'https://connect.facebook.net/en_US/fbevents.js');
        fbq('init', '#{pixel_id}');
        fbq('track', 'PageView');
      JAVASCRIPT
    end +
      content_tag(:noscript) do
        image_tag("https://www.facebook.com/tr?id=#{pixel_id}&ev=PageView&noscript=1",
                  height: 1, width: 1, style: "display:none")
      end
  end

  def fb_track_event(event_name, params = {})
    return unless Rails.env.production? || Rails.env.staging?
    pixel_id = Settings.facebook_pixel.id.presence || Setting.find_by(key: "facebook_pixel")&.value
    return unless pixel_id.present?

    content_tag(:script) do
      if params.any?
        "fbq('track', '#{event_name}', #{params.to_json});".html_safe
      else
        "fbq('track', '#{event_name}');".html_safe
      end
    end
  end
end
