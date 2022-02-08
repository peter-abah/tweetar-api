# Returns a json representation of user
class UserRepresenter < DataRepresenter
  include Rails.application.routes.url_helpers

  attr_reader :add_token

  def initialize(data, add_token: false)
    super(data)
    @add_token = add_token
  end

  private

  def extra_data
    profile_image_url = data.profile_image.attached? ? rails_blob_path(data.profile_image, disposition: "attachment") : nil
    cover_image_url = data.cover_image.attached? ? rails_blob_path(data.cover_image, disposition: "attachment") : nil

    extra = {
      profile_image: profile_image_url,
      cover_image: cover_image_url
    }
    extra.merge(user_token)
  end

  def user_token
    add_token ? { token: AuthenticationTokenService.call(data.id) } : {}
  end
end
