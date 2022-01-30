# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  first_name      :string
#  last_name       :string
#  password_digest :string
#  bio             :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  email           :string
#

class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true, length: { minimum: 2 }
  validates :password, presence: true, length: { minimum: 8 }, on: :create
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }
  validates :bio, length: { minimum: 2 }, allow_blank: true
  validates :email, presence: true, email: true

  has_many :tweets

  def as_json(options = {}, add_token: false)
    user_token = add_token ? { token: AuthenticationTokenService.call(id) } : {}
    super(except: :password_digest).merge(user_token)
  end
end
