FactoryBot.define do
  factory :news do
    sequence(:title) { |n| "title_#{n}" }
    association :news_category
  end
end
