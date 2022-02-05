# == Schema Information
#
# Table name: tweets
#
#  id             :integer          not null, primary key
#  body           :text
#  parent_id      :integer
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  replies_count  :integer
#  retweets_count :integer
#

class Tweet < ApplicationRecord
  validates :body, presence: true, length: { in: 2..250 }

  belongs_to :user
  belongs_to :parent, class_name: 'Tweet', optional: true, counter_cache: :replies_count
  has_many :replies, foreign_key: 'parent_id', class_name: 'Tweet'
  has_many :retweets, -> { includes([:tweet]) }

  def as_json(options = {})
    options = options.merge(user: { except: :password_digest })
    super(options)
  end
end
