FactoryBot.define do
  factory :question do
    package { nil }
    name { "MyString" }
    answer { "MyText" }
    kind { 1 }
    score { 1 }
    enabled { false }
  end
end
