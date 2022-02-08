# Returns a json representation of a list of users
class UsersRepresenter < ListRepresenter
  attr_reader :add_token

  def initialize(list, add_token: false)
    super(list)
    @list = list
    @add_token = add_token
  end

  def list_json
    list.map do |user|
      UserRepresenter.new(user).as_json
    end
  end
end
