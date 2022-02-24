# == Schema Information
#
# Table name: bookmarks
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  tweet_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :tweet

  default_scope { order(updated_at: :desc) }

  def as_json(options = {})
    options = options.merge(methods: :type)
    super(options)
  end

  def type
    'bookmark'
  end
end
