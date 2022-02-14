def seed_followers
  User.all.each do |user|
    seed_followers_for user
  end
end

def seed_followers_for(user)
  users_to_follow = User.order('RANDOM()').where.not(id: user.id).take(rand(21))
  users_to_follow.each do |user_to_follow|
    Follow.create!(follower_id: user.id, followed_id: user_to_follow.id)
  end
end
