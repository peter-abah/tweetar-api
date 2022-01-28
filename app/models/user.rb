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
#

class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true, length: { minimum: 2 }
  validates :password, presence: true, length: { minimum: 8 }
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }
  validates :bio, length: { minimum: 2 }, allow_blank: true

  def as_json(options={})
    {
      id: id,
      username: username,
      first_name: first_name,
      last_name: last_name,
      bio: bio,
      token: AuthenticationTokenService.call(id)
    }
  end
end
