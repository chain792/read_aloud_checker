FactoryBot.define do
  factory :training do
    sequence(:title, "title_1")
    sequence(:body, "body_1")

    association :user
    association :sentence, factory: :user_sentence
  end
end
