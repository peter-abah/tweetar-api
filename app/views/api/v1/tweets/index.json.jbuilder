json.list do
  json.array! @tweets do |tweet|
    json.cache! ['v1', tweet], expires_in: 10.minutes do
      json.partial! 'api/v1/tweets/tweet', locals: { tweet: tweet, options: { add_parent: true } }
    end
  end
end

json.extract! @tweets, :size, :current_page, :total_pages
json.total_size @tweets.total_count

json.next_page @tweets.current_page + 1 if @tweets.current_page < @tweets.total_pages
json.prev_page @tweets.current_page - 1 if @tweets.current_page > 1
