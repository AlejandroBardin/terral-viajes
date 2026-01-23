module StructuredDataHelper
  def package_structured_data(package)
    return unless package.present?

    data = {
      "@context": "https://schema.org",
      "@type": "TouristTrip",
      "name": package.title,
      "description": package.description,
      "touristType": package.ideal_profile || [],
      "offers": {
        "@type": "Offer",
        "price": package.price,
        "priceCurrency": "ARS",
        "availability": "https://schema.org/InStock",
        "url": package_url(package)
      }
    }

    # Add optional fields
    data[:image] = url_for(package.main_image) if package.main_image.attached?
    data[:startDate] = package.start_date.iso8601 if package.start_date.present?
    data[:endDate] = package.end_date.iso8601 if package.end_date.present?

    if package.duration.present?
      data[:duration] = package.duration
    end

    content_tag(:script, type: "application/ld+json") do
      data.to_json.html_safe
    end
  end

  def organization_structured_data
    data = {
      "@context": "https://schema.org",
      "@type": "TravelAgency",
      "name": "Terral Viajes",
      "url": root_url,
      "logo": asset_url("logo.png"),
      "contactPoint": {
        "@type": "ContactPoint",
        "telephone": (Setting.find_by(key: "whatsapp_number")&.value || "+5491112345678"),
        "contactType": "Customer Service",
        "availableLanguage": [ "Spanish" ]
      },
      "sameAs": [
        # Add social media URLs here
      ]
    }

    content_tag(:script, type: "application/ld+json") do
      data.to_json.html_safe
    end
  end
end
