# frozen_string_literal: true

class FeaturesBadgeComponentPreview < ViewComponent::Preview
  def default
    render(FeaturesBadgeComponent.new)
  end
end
