def create_tweet(user)
  user.tweets.create!({
    body: Faker::Lorem.paragraph
  })
end

def seed_tweets(n = 20)
  User.all.each do |user|
    0.upto(n) { create_tweet(user) }
  end
end
