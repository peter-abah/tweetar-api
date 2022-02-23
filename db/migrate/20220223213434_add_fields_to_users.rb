class AddFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :location, :string, default: ''
    add_column :users, :website, :string, default: ''
  end
end
