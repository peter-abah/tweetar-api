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
  has_many :retweets

  def as_json(options = {})
    extra_data = {
      # not using the include option since it will send the users password digest
      user: user.as_json,
      replies_no: replies.size,
      retweets_no: retweets.size
    }
    super(options).merge(extra_data)
  end
end
