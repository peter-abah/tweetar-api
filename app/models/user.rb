# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  username             :string
#  first_name           :string
#  last_name            :string
#  password_digest      :string
#  bio                  :text             default("")
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  email                :string
#  followers_count      :integer          default("0")
#  followed_users_count :integer          default("0")
#

class User < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_secure_password

  validates :username, presence: true, uniqueness: true, length: { minimum: 2 }
  validates :password, presence: true, length: { minimum: 8 }, on: :create
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }
  validates :bio, length: { maximum: 250 }
  validates :email, presence: true, email: true, uniqueness: true

  has_many :tweets
  has_many :retweets, -> { includes(
    user: { profile_image_attachment: :blob, cover_image_attachment: :blob },
    tweet: { images_attachments: :blob }
  )}

  has_many :likes, -> { includes(
    user: { profile_image_attachment: :blob, cover_image_attachment: :blob },
    tweet: { images_attachments: :blob }
  )}

  has_one_attached :profile_image, dependent: :destroy
  has_one_attached :cover_image, dependent: :destroy

  has_many :received_follows, foreign_key: :followed_id, class_name: 'Follow', counter_cache: :followers_count
  has_many :sent_follows, foreign_key: :follower_id, class_name: 'Follow', counter_cache: :followed_users_count
  has_many :followers, -> { includes(
    profile_image_attachment: :blob,
    cover_image_attachment: :blob
  ) }, through: :received_follows, source: :follower

  has_many :followed_users, -> { includes(
    :tweets,
    :retweets,
    profile_image_attachment: :blob,
    cover_image_attachment: :blob
  ) }, through: :sent_follows, source: :followed

  def self.filter_by_query(query)
    query = "%#{query.downcase}%"
    where("CONCAT(first_name, ' ', last_name) LIKE ?", query)
  end

  def as_json(options = {})
    methods = %i[name profile_image_url cover_image_url] + (options[:methods] || [])
    options = options.merge(except: :password_digest, methods: methods)
    super(options)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def profile_image_url
    profile_image.attached? ? rails_blob_path(profile_image, disposition: "attachment") : nil
  end

  def cover_image_url
    cover_image.attached? ? rails_blob_path(cover_image, disposition: "attachment") : nil
  end

  def authentication_token
    AuthenticationTokenService.call(id)
  end

  # Returns associations to be added to json
  def associations_for_json
    []
  end
end
