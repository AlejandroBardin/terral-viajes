require 'rails_helper'

RSpec.describe "packages/edit", type: :view do
  let(:package) {
    Package.create!(
      title: "MyString",
      price: "9.99",
      stars: "MyString",
      duration: "MyString",
      dates: "MyString",
      regime: "MyString",
      featured: false,
      description: "MyText"
    )
  }

  before(:each) do
    assign(:package, package)
  end

  it "renders the edit package form" do
    render

    assert_select "form[action=?][method=?]", package_path(package), "post" do
      assert_select "input[name=?]", "package[title]"

      assert_select "input[name=?]", "package[price]"

      assert_select "input[name=?]", "package[stars]"

      assert_select "input[name=?]", "package[duration]"

      assert_select "input[name=?]", "package[dates]"

      assert_select "input[name=?]", "package[regime]"

      assert_select "input[name=?]", "package[featured]"

      assert_select "textarea[name=?]", "package[description]"
    end
  end
end
