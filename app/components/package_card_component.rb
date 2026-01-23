class PackageCardComponent < ViewComponent::Base
  def initialize(package:)
    @package = package
  end

  def main_image_url
    if @package.main_image.attached?
      url_for(@package.main_image)
    else
      "https://placehold.co/600x400?text=No+Image"
    end
  end

  def render_stars
    @package.stars
  end
end
