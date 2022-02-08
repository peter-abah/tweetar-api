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

  has_one_attached :profile_image, dependent: :destroy
  has_one_attached :cover_image, dependent: :destroy

  has_many :received_follows, foreign_key: :followed_id, class_name: 'Follow', counter_cache: :followers_count
  has_many :sent_follows, foreign_key: :follower_id, class_name: 'Follow', counter_cache: :followed_users_count
  has_many :followers, through: :received_follows, source: :follower
  has_many :followed_users, -> { includes(%i[tweets retweets]) }, through: :sent_follows, source: :followed

  def as_json(options = {})
    options = options.merge(except: :password_digest)
    super(options)
  end
end
