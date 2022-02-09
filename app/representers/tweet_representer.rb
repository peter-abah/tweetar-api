# Returns a json representation of tweet
class TweetRepresenter < DataRepresenter
  include Rails.application.routes.url_helpers

  attr_reader :user

  def initialize(data, user = nil)
    super(data)
    @user = user
  end

  private

  def extra_data
    image_urls = data.images.map { |img| rails_blob_path(img, disposition: "attachment") }
    {
      user: data.user.as_json,
      image_urls: image_urls,
      liked_by_user: liked_by_user?,
      retweeted_by_user: retweeted_by_user?
    }
  end

  def liked_by_user?
    user ? data.likes.exists?(user: user) : false
  end

  def retweeted_by_user?
    user ? data.retweets.exists?(user: user) : false
  end
end
