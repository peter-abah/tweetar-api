# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  tweet_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Like < ApplicationRecord
  validates :user_id, presence: true
  validates :tweet_id, presence: true

  belongs_to :user
  belongs_to :tweet, counter_cache: true
end
