require 'rails_helper'

RSpec.describe "packages/show", type: :view do
  before(:each) do
    assign(:package, Package.create!(
      title: "Title",
      price: "9.99",
      stars: "Stars",
      duration: "Duration",
      dates: "Dates",
      regime: "Regime",
      featured: false,
      description: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Stars/)
    expect(rendered).to match(/Duration/)
    expect(rendered).to match(/Dates/)
    expect(rendered).to match(/Regime/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/MyText/)
  end
end
