class FeedGenerator
  def call(current_user)
    users(current_user).reduce([]) { |acc, user| acc + user.tweets + user.retweets }
  end
  
  # returns users that current_user follows and users that current_user
  # followed users follow
  def users(current_user)
    followed_users = current_user.followed_users.
                       include(:retweets, :tweets, followed_users: %i[tweets retweets])
    result = followed_users.reduce([]) { |acc, user| acc + user.followed_users }
    followed_users + result
  end
end
