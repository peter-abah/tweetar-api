class AddEmailToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :email, :string, unique: true
    add_index :users, :email
    add_index :users, :username
  end
end
