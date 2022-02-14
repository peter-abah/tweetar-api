def seed_users(n = 20)
  0.upto(n) do
    url = Faker::Avatar.image
    filename = File.basename(URI.parse(url).path)
    profile_img = URI.open(url)
    cover_img = File.open("#{Rails.root}/app/assets/images/1.jpg")

    user = User.create!({
      username: Faker::Internet.unique.username(separators: '_'),
      email: Faker::Internet.unique.email,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      bio: 'I am a random user',
      password: 'password'
    })

    user.profile_image.attach(io: profile_img, filename: filename, content_type: 'image/jpeg')
    user.cover_image.attach(io: cover_img, filename: 'cover_image', content_type: 'image/jpeg')
  end
end
