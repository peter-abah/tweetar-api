# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  username             :citext
#  first_name           :string
#  last_name            :string
#  password_digest      :string
#  bio                  :text             default("")
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  email                :citext
#  followers_count      :integer          default("0")
#  followed_users_count :integer          default("0")
#  tweets_count         :integer          default("0")
#  location             :string           default("")
#  website              :string           default("")
#

class User < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_secure_password

  validates :username, presence: true, uniqueness: true, format: { with: /\A\w+\z/ }, length: { minimum: 2 }
  validates :password, presence: true, length: { minimum: 8 }, on: :create
  validates :first_name, presence: true
  validates :bio, length: { maximum: 250 }
  validates :location, length: { maximum: 100 }
  validates :website, length: { maximum: 100 }
  validates :email, presence: true, email: true, uniqueness: true

  has_many :tweets, dependent: :destroy
  has_many :retweets, lambda {
                        includes(
                          user: { profile_image_attachment: :blob, cover_image_attachment: :blob },
                          tweet: { images_attachments: :blob }
                        )
                      }, dependent: :destroy

  has_many :likes, lambda {
                     includes(
                       user: { profile_image_attachment: :blob, cover_image_attachment: :blob },
                       tweet: { images_attachments: :blob }
                     )
                   }, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_tweets, through: :bookmarks, source: :tweet

  has_one_attached :profile_image, dependent: :destroy
  has_one_attached :cover_image, dependent: :destroy

  has_many :received_follows, foreign_key: :followed_id, class_name: 'Follow', dependent: :destroy
  has_many :sent_follows, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy
  has_many :followers, through: :received_follows, source: :follower
  has_many :followed_users, through: :sent_follows, source: :followed

  def self.filter_by_query(query)
    query = "%#{query.downcase}%"
    where("LOWER(CONCAT(first_name, ' ', last_name)) LIKE ?", query)
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
    profile_image.attached? ? rails_blob_url(profile_image, disposition: 'attachment') : nil
  end

  def cover_image_url
    cover_image.attached? ? rails_blob_url(cover_image, disposition: 'attachment') : nil
  end

  def recommended_follows
    users = followed_users.joins(:followed_users).includes(:sent_follows)

    result = users.reduce([]) do |res, followed_user|
      recommended = followed_user.followed_users
      res.concat(recommended)
    end

    result = result.reject { |user| [*followed_user_ids, id].include? user.id }
    result.uniq
  end

  def followed_by_user?(user)
    received_follows.exists?(follower: user)
  end

  def following_user?(user)
    sent_follows.exists?(followed: user)
  end

  def authentication_token
    AuthenticationTokenService.call(id)
  end

  # Returns associations to be added to json
  def associations_for_json
    []
  end
end
