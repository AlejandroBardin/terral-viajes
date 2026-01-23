require 'rails_helper'

RSpec.describe "packages/index", type: :view do
  before(:each) do
    assign(:packages, [
      Package.create!(
        title: "Title",
        price: "9.99",
        stars: "Stars",
        duration: "Duration",
        dates: "Dates",
        regime: "Regime",
        featured: false,
        description: "MyText"
      ),
      Package.create!(
        title: "Title",
        price: "9.99",
        stars: "Stars",
        duration: "Duration",
        dates: "Dates",
        regime: "Regime",
        featured: false,
        description: "MyText"
      )
    ])
  end

  it "renders a list of packages" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Stars".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Duration".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Dates".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Regime".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
