json.list do
  json.array! @feed do |feed_data|
    if feed_data.type == 'tweet'
      json.partial! 'api/v1/tweets/tweet', locals: { tweet: feed_data }
    else
      json.partial! 'api/v1/tweet_actions/tweet_action', locals: { tweet_action: feed_data }
      # end
    end
  end
end

json.extract! @feed, :size, :current_page, :total_pages
json.total_size @feed.total_count

json.next_page @feed.current_page + 1 if @feed.current_page < @feed.total_pages
json.prev_page @feed.current_page - 1 if @feed.current_page > 1
