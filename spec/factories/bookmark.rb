FactoryBot.define do
  factory :bookmark do
    association :user
    association :tweet
  end
end