FactoryBot.define do
  factory :news do
    sequence(:title) { |n| "title_#{n}" }
  end
end
