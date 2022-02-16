def seed_retweets
  User.all.each do |user|
    seed_retweets_for user
  end
end

def seed_retweets_for(user)
  tweets = Tweet.where(id: Tweet.pluck(:id).sample(rand(21)))
  tweets.each { |tweet| Retweet.create!(tweet_id: tweet.id, user_id: user.id) }
end
