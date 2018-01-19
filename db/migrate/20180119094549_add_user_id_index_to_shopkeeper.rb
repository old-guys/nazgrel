class AddUserIdIndexToShopkeeper < ActiveRecord::Migration[5.1]
  def change
    add_index :shopkeepers, :user_id
  end
end