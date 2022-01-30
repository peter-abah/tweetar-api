# Returns a json representation of a list of users
class UsersRepresenter
  def initialize(users)
    @users = users
  end

  def as_json(add_token: false)
    @users.map do |user|
      user_token = add_token ? { token: AuthenticationTokenService.call(@user.id) } : {}
      user_token.merge(user.as_json)
    end
  end
end
