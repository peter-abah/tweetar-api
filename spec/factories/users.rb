# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  username             :citext
#  first_name           :string
#  last_name            :string
#  password_digest      :string
#  bio                  :text             default("")
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  email                :citext
#  followers_count      :integer          default("0")
#  followed_users_count :integer          default("0")
#  tweets_count         :integer          default("0")
#  location             :string           default("")
#  website              :string           default("")
#

FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username(specifier: 5..10, separators: '_') }
    password { 'password' }
    password_confirmation { 'password' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
  end
end
