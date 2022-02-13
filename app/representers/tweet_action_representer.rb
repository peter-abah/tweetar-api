# Returns a json representation of tweet
class TweetActionRepresenter < TweetRepresenter
  attr_reader :tweet_action

  def initialize(model, options, extra_data)
    super(model.tweet, options, extra_data)
    @user = extra_data[:user]
    @tweet_action = model
  end

  def as_json
    {
      id: tweet_action.id,
      tweet: model.as_json(options).merge(extra_data),
      user: Representer.new(tweet_action.user, options, { user: user }).as_json,
      type: tweet_action.type,
      data_id: "#{tweet_action.type}-#{tweet_action.id}"
    }
  end
end
