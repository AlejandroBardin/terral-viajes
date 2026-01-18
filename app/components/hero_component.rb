# frozen_string_literal: true

class HeroComponent < ViewComponent::Base
  def initialize(title:, subtitle:, image_url:)
    @title = title
    @subtitle = subtitle
    @image_url = image_url
  end
end
