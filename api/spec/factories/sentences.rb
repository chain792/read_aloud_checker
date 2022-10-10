FactoryBot.define do
  factory :user_sentence, class: 'Sentence' do
    sequence(:title, "title_1")
    sequence(:body, "body_1")

    association :creater, factory: :user
  end

  factory :news_sentence, class: 'Sentence' do
    sequence(:title, "title_1")
    sequence(:body, "body_1")

    association :creater, factory: :news
  end
end
