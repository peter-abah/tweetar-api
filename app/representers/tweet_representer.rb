# Returns a json representation of tweet
class TweetRepresenter < DataRepresenter
  attr_reader :user

  def initialize(model, options, extra_data)
    super(model, options, extra_data)
    @user = extra_data[:user]
  end

  private

  def extra_data
    extra = {
      liked_by_user: liked_by_user?,
      retweeted_by_user: retweeted_by_user?
    }
    super().merge(extra)
  end

  def liked_by_user?
    user ? model.likes.exists?(user: user) : false
  end

  def retweeted_by_user?
    user ? model.retweets.exists?(user: user) : false
  end
end
