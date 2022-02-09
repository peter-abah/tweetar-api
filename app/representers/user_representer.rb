# Returns a json representation of user
class UserRepresenter < DataRepresenter
  attr_reader :add_token

  def initialize(data, add_token: false)
    super(data)
    @add_token = add_token
  end

  private

  def extra_data
    user_token
  end

  def user_token
    add_token ? { token: AuthenticationTokenService.call(data.id) } : {}
  end
end
