class FeedGenerator
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def feed
    tweets = users.reduce([]) do |acc, user|
      acc + user.tweets + user.retweets
    end

    tweets = pad_tweets(tweets) if tweets.count < 25
    Kaminari.paginate_array(tweets)
  end

  def random_tweets(n = 25)
    Tweet.order('RANDOM()').where.not(user: current_user).take(n)
  end

  private

  # returns users that current_user follows and users that current_user
  # followed users follow
  def users
    followed_users = current_user.followed_users.includes(:followed_users)
    result = followed_users.reduce([]) { |acc, user| acc + user.followed_users }
    followed_users + result
  end

  def pad_tweets(tweets)
    diff = 25 - tweets.count
    tweets + random_tweets(diff)
  end
end
