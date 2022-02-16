def seed_followers
  User.all.each do |user|
    seed_followers_for user
  end
end

def seed_followers_for(user)
  users_to_follow = User.where(id: User.pluck(:id).sample(rand(21))).where.not(id: user.id)

  users_to_follow.each do |user_to_follow|
    Follow.create!(follower_id: user.id, followed_id: user_to_follow.id)
  end
end
