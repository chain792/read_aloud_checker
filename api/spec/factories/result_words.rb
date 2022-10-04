FactoryBot.define do
  factory :result_word do
    sequence(:position, 1)

    association :training
  end
end
