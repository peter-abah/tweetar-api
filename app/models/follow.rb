# == Schema Information
#
# Table name: follows
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Follow < ApplicationRecord
  belongs_to :followed, class_name: 'User', foreign_key: 'followed_id', counter_cache: :followers_count
  belongs_to :follower, class_name: 'User', foreign_key: 'follower_id', counter_cache: :followed_users_count

  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
