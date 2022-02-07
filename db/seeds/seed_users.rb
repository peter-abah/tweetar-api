def seed_users(n = 20)
  0.upto(n) do
    url = Faker::Avatar.image
    filename = File.basename(URI.parse(url).path)
    file = URI.open(url)

    user = User.create!({
      username: Faker::Internet.unique.username,
      email: Faker::Internet.unique.email,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      bio: 'I am a random user',
      password: 'password'
    })

    user.profile_image.attach(io: file, filename: filename, content_type: 'image/jpeg')
  end
end