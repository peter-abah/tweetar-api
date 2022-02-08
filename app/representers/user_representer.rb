# Returns a json representation of user
class UserRepresenter
  include Rails.application.routes.url_helpers
  
  attr_reader :user, :add_token

  def initialize(user)
    @user = user
  end

  def as_json(add_token: false)
    @add_token = add_token
    user.as_json.merge(extra_data)
  end

  private

  def extra_data
    profile_image_url = user.profile_image.attached? ? rails_blob_path(user.profile_image, disposition: "attachment") : nil
    cover_image_url = user.cover_image.attached? ? rails_blob_path(user.cover_image, disposition: "attachment") : nil

    data = {
      profile_image: profile_image_url,
      cover_image: cover_image_url
    }
    data.merge(user_token)
  end

  def user_token
    add_token ? { token: AuthenticationTokenService.call(user.id) } : {}
  end
end

