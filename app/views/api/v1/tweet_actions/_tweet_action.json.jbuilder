
hash = {
  id: tweet_action.id,
  data_id: "#{tweet_action.type}-#{tweet_action.id}"
}

json.partial! 'api/v1/tweets/tweet',
              locals: { tweet: tweet_action.tweet, options: { add_parent: true } }
json.user { json.partial! 'api/v1/users/user', locals: { user: tweet_action.user } }
json.merge! hash
