require 'rails_helper'

RSpec.describe "packages/new", type: :view do
  before(:each) do
    assign(:package, Package.new(
      title: "MyString",
      price: "9.99",
      stars: "MyString",
      duration: "MyString",
      dates: "MyString",
      regime: "MyString",
      featured: false,
      description: "MyText"
    ))
  end

  it "renders new package form" do
    render

    assert_select "form[action=?][method=?]", packages_path, "post" do
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
