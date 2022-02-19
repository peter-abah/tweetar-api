json.merge! user.as_json

if defined?(options[:add_token]) && options[:add_token]
  json.authentication_token AuthenticationTokenService.call(user.id)
end


json.followed_by_user user.followed_by_user? @current_user
json.following_user user.following_user? @current_user
