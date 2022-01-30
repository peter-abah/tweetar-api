# Returns a json representation of user
class UserRepresenter
  def initialize(user)
    @user = user
  end

  def as_json(add_token: false)
    user_token = add_token ? { token: AuthenticationTokenService.call(@user.id) } : {}
    user_token.merge(@user.as_json)
  end
end

