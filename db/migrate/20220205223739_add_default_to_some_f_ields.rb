class AddDefaultToSomeFIelds < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :bio, ''
    change_column_default :tweets, :likes_count, 0
    change_column_default :tweets, :retweets_count, 0
    change_column_default :tweets, :replies_count, 0
  end
end
