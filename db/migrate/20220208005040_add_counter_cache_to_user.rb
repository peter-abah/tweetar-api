class AddCounterCacheToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :followers_count, :integer, default: 0
    add_column :users, :followed_users_count, :integer, default: 0
  end
end
