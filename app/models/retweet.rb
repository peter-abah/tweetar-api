# == Schema Information
#
# Table name: retweets
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  tweet_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Retweet < ApplicationRecord
  validates :user_id, presence: true
  validates :tweet_id, presence: true

  belongs_to :user
  belongs_to :tweet, counter_cache: true

  default_scope { order(updated_at: :desc) }

  def as_json(options = {})
    options = options.merge(methods: :type)
    super(options)
  end

  def type
    'retweet'
  end
end
