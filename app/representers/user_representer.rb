# Returns a json representation of tweet
class UserRepresenter < DataRepresenter
  private

  def extra_data
    extra = {
      followed_by_user: followed_by_user?,
      following_user: following_user?
    }
    super().merge(extra)
  end

  def followed_by_user?
    user ? model.received_follows.exists?(follower: user) : false
  end

  def following_user?
    user ? model.sent_follows.exists?(followed: user) : false
  end
end
