# Returns a json representation of tweet
class TweetRepresenter
  attr_reader :tweet, :user

  def initialize(tweet, user = nil)
    @tweet = tweet
    @user = user
  end

  def as_json
    tweet.as_json.merge(extra_data)
  end

  private

  def extra_data
    image_urls = tweet.images.map { |img| rails_blob_path(img, disposition: "attachment") }
    {
      user: tweet.user.as_json,
      image_urls: image_urls,
      liked_by_user: liked_by_user?,
      retweeted_by_user: retweeted_by_user?
    }
  end

  def liked_by_user?
    user ? tweet.likes.exists?(user: user) : false
  end

  def retweeted_by_user?
    user ? tweet.retweets.exists?(user: user) : false
  end
end