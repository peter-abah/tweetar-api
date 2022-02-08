# Returns a json representation of a list of users
class TweetsRepresenter < ListRepresenter
  attr_reader :user

  def initialize(list, user = nil)
    super(list)
    @user = user
  end

  def list_json
    list.map do |tweet|
      TweetRepresenter.new(tweet, user).as_json
    end
  end
end
