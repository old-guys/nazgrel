class AddTimestampIndexToShopkeeper < ActiveRecord::Migration[5.2]
  def change
    add_index :shopkeepers, :created_at
    add_index :shopkeepers, :updated_at
  end
end