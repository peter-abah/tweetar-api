json.tweet do
  json.merge! tweet.as_json
  json.liked_by_user tweet.liked_by_user?(@current_user) if @current_user
  json.retweeted_by_user tweet.retweeted_by_user?(@current_user) if @current_user

  # json.cache! ['v1', tweet.user], expires_in: 1.minutes do
    json.user { json.partial! 'api/v1/users/user', locals: { user: tweet.user } }
  # end

  # only show parent if the option is specified and parent exists
  if defined?(options) && options[:add_parent] && tweet.parent
    # json.cache! ['v1', tweet.parent], expires_in: 1.minutes do
      json.parent { json.partial! 'api/v1/tweets/tweet', tweet: tweet.parent }
    # end
  end
end

json.id tweet.id
json.data_id "#{tweet.type}-#{tweet.id}"
