# Returns a json representation of a list of users
class UsersRepresenter
  attr_reader :users

  def initialize(users)
    @users = users
  end

  def as_json(add_token: false)
    @users.map do |user|
      UserRepresenter.new(user).as_json(add_token: add_token)
    end
  end
end
