class AddCounterCacheToTweets < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :replies_count, :integer
    add_column :tweets, :retweets_count, :integer
  end
end
