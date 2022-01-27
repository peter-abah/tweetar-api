FactoryBot.define do
  factory :user do
    username { Faker::Internet.username(specifier: 5..10) }
    password { 'password' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
