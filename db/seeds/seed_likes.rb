def seed_likes
  User.all.each do |user|
    seed_likes_for user
  end
end

def seed_likes_for(user)
  tweets = Tweet.where(id: Tweet.pluck(:id).sample(rand(21)))
  tweets.each { |tweet| Like.create!(tweet_id: tweet.id, user_id: user.id) }
end
