# Returns a json representation of a list of users
class TweetsRepresenter
  attr_reader :tweets, :user

  def initialize(tweets, user = nil)
    @tweets = tweets
    @user = user
  end

  def as_json
    tweets.map do |tweet|
      TweetRepresenter.new(tweet, user).as_json
    end
  end
end
