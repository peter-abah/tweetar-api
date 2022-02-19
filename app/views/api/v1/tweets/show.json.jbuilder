json.partial! 'api/v1/tweets/tweet',
              locals: { tweet: @tweet, options: { add_parent: true } }
