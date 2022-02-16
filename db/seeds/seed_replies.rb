def seed_replies
  User.all.each do |user|
    seed_replies_for user
  end
end

def seed_replies_for(user)
  tweets = Tweet.where(id: Tweet.pluck(:id).sample(rand(50)))
  tweets.each do |tweet|
    Tweet.create!(
      body: Faker::Lorem.paragraph,
      user_id: user.id,
      parent_id: tweet.id
    )
  end
end
