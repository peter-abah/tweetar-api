json.list do
  json.array! @users do |user|
    json.cache! ['v1', user], expires_in: 10.minutes do
      json.partial! 'api/v1/users/user', locals: { user: user }
    end
  end
end

json.extract! @users, :size, :current_page, :total_pages
json.total_size @users.total_count

json.next_page @users.current_page + 1 if @users.current_page < @users.total_pages
json.prev_page @users.current_page - 1 if @users.current_page > 1
