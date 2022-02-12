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

  default_scope { order(updated_at: :desc) }

  def as_json(options = {})
    extra_data = {
      is_like: true
    }
    super(options).merge(extra_data)
  end

  def associations_for_json
    %i[user tweet]
  end
end
