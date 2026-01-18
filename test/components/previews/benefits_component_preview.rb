# frozen_string_literal: true

class BenefitsComponentPreview < ViewComponent::Preview
  def default
    render(BenefitsComponent.new)
  end
end
