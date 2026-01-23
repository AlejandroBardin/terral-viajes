module MetaTagsHelper
  def meta_tags_for(resource = nil)
    title = page_title(resource)
    description = page_description(resource)
    image_url = page_image_url(resource)

    tags = []

    # Basic meta tags
    tags << tag.meta(name: "description", content: description)

    # Open Graph tags
    tags << tag.meta(property: "og:title", content: title)
    tags << tag.meta(property: "og:description", content: description)
    tags << tag.meta(property: "og:image", content: image_url)
    tags << tag.meta(property: "og:url", content: request.original_url)
    tags << tag.meta(property: "og:type", content: og_type(resource))
    tags << tag.meta(property: "og:site_name", content: "Terral Viajes")

    # Twitter Card tags
    tags << tag.meta(name: "twitter:card", content: "summary_large_image")
    tags << tag.meta(name: "twitter:title", content: title)
    tags << tag.meta(name: "twitter:description", content: description)
    tags << tag.meta(name: "twitter:image", content: image_url)

    # Canonical URL
    tags << tag.link(rel: "canonical", href: canonical_url(resource))

    safe_join(tags, "\n")
  end

  private

  def page_title(resource)
    case resource
    when Package
      "#{resource.title} - Terral Viajes"
    else
      content_for(:title) || "Terral Viajes - Tu próxima aventura comienza aquí"
    end
  end

  def page_description(resource)
    case resource
    when Package
      truncate(resource.description, length: 160)
    else
      "Descubre paquetes turísticos increíbles con Terral Viajes. Experiencias únicas en Argentina y Latinoamérica."
    end
  end

  def page_image_url(resource)
    case resource
    when Package
      if resource.main_image.attached?
        url_for(resource.main_image)
      else
        asset_url("default-og-image.png")
      end
    else
      asset_url("default-og-image.png")
    end
  end

  def og_type(resource)
    resource.is_a?(Package) ? "product" : "website"
  end

  def canonical_url(resource)
    case resource
    when Package
      package_url(resource)
    else
      request.base_url + request.path
    end
  end
end
