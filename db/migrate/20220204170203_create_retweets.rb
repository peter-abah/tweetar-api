class CreateRetweets < ActiveRecord::Migration[7.0]
  def change
    create_table :retweets do |t|
      t.references :user, foreign_key: true
      t.references :tweet, foreign_key: true
      
      t.timestamps
    end
  end
end
