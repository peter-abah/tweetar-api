def seed_likes
  User.all.each do |user|
    seed_likes_for user
  end
end

def seed_likes_for(user)
  tweets = Tweet.select(:id).order('RANDOM()').take(20)
  tweets.each { |tweet| Like.create!(tweet_id: tweet.id, user_id: user.id) }
end
