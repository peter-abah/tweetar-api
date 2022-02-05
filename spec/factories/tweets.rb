# == Schema Information
#
# Table name: tweets
#
#  id             :integer          not null, primary key
#  body           :text
#  parent_id      :integer
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  replies_count  :integer
#  retweets_count :integer
#

FactoryBot.define do
  factory :tweet do
    association :user
    body { Faker::Lorem.paragraph }
  end
end
