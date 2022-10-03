FactoryBot.define do
  factory :news_category do
    sequence(:name) { |n| "name_#{n}" }
  end
end
