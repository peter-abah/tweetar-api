def seed_users(n = 100)
  0.upto(n) do
    User.create!({
      username: Faker::Internet.unique.username,
      email: Faker::Internet.unique.email,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      bio: 'I am a random user',
      password: 'password',
    })
  end
end