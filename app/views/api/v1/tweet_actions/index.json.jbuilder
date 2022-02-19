json.list do
  json.array! @tweet_actions do |tweet_action|
    json.cache! ['v1', tweet_action], expires_in: 10.minutes do
      json.partial! 'api/v1/tweet_actions/tweet_action', locals: { tweet_action: tweet_action }
    end
  end
end

json.extract! @tweet_actions, :size, :current_page, :total_pages
json.total_size @tweet_actions.total_count

json.next_page @tweet_actions.current_page + 1 if @tweet_actions.current_page < @tweet_actions.total_pages
json.prev_page @tweet_actions.current_page - 1 if @tweet_actions.current_page > 1
