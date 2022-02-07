# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  first_name      :string
#  last_name       :string
#  password_digest :string
#  bio             :text             default("")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  email           :string
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
  has_many :retweets
  has_many :likes

  has_one_attached :profile_image
  has_one_attached :cover_image

  has_many :received_follows, foreign_key: :followed_id, class_name: 'Follow'
  has_many :sent_follows, foreign_key: :follower_id, class_name: 'Follow'
  has_many :followers, through: :received_follows, source: :follower
  has_many :followed_users, -> { includes(%i[tweets retweets]) }, through: :sent_follows, source: :followed

  def as_json(options = {})
    options = options.merge(except: :password_digest)
    super(options).merge(extra_data)
  end

  private

  def extra_data
    profile_image_url = profile_image.attached? ? rails_blob_path(profile_image, disposition: "attachment") : nil
    cover_image_url = cover_image.attached? ? rails_blob_path(cover_image, disposition: "attachment") : nil

    {
      profile_image: profile_image_url,
      cover_image: cover_image_url
    }
  end
end
