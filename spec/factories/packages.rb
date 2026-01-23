FactoryBot.define do
  factory :package do
    title { "MyString" }
    price { "9.99" }
    stars { "MyString" }
    duration { "MyString" }
    dates { "MyString" }
    regime { "MyString" }
    featured { false }
    description { "MyText" }
  end
end
