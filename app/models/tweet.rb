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
#  replies_count  :integer          default("0")
#  retweets_count :integer          default("0")
#  likes_count    :integer          default("0")
#

class Tweet < ApplicationRecord
  include Rails.application.routes.url_helpers

  validates :body, presence: true, length: { in: 1..250 }
  validates :images, limit: { min: 0, max: 4 }, content_type: %i[png jpg jpeg gif]

  belongs_to :user, counter_cache: true
  belongs_to :parent, class_name: 'Tweet', optional: true, counter_cache: :replies_count
  has_many :replies, foreign_key: 'parent_id', class_name: 'Tweet'
  has_many :retweets, -> { includes(
    user: { profile_image_attachment: :blob, cover_image_attachment: :blob },
    tweet: { images_attachments: :blob }
  )}

  has_many :likes, -> { includes(
    user: { profile_image_attachment: :blob, cover_image_attachment: :blob },
    tweet: { images_attachments: :blob }
  )}

  has_many_attached :images

  default_scope { order(updated_at: :desc) }

  def self.filter_by_query(query)
    query = "%#{query.downcase}%"
    where('body LIKE ?', query)
  end

  def as_json(options = {})
    options = options.merge(methods: :image_urls)
    super(options)
  end

  def image_urls
    images.map { |img| rails_blob_url(img, disposition: "attachment") }
  end

  def liked_by_user?(user)
    likes.exists?(user: user)
  end

  def retweeted_by_user?(user)
    retweets.exists?(user: user)
  end

  def type
    'tweet'
  end
end
