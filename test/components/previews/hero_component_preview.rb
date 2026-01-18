# frozen_string_literal: true

class HeroComponentPreview < ViewComponent::Preview
  def default
    render(HeroComponent.new(title: "title", subtitle: "subtitle", image_url: "image_url"))
  end
end
