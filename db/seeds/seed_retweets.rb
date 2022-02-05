def seed_retweets
  User.all.each do |user|
    seed_retweets_for user
  end
end

def seed_retweets_for(user)
  tweets = Tweet.select(:id).order('RANDOM()').take(500)
  tweets.each { |tweet| Retweet.create!(tweet_id: tweet.id, user_id: user.id) }
end
