class AddLikesCounterToTweets < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :likes_count, :integer
  end
end
