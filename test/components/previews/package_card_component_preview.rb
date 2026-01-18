# frozen_string_literal: true

class PackageCardComponentPreview < ViewComponent::Preview
  def default
    render(PackageCardComponent.new(package: "package"))
  end
end
