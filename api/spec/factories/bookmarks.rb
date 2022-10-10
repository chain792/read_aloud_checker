FactoryBot.define do
  factory :bookmark do
    association :user
    association :sentence, factory: :user_sentence
  end
end
