class AddShopkeeperRefToChannel < ActiveRecord::Migration[5.1]
  def change
    add_column :channels, :shopkeeper_user_id, :bigint, comment: "店主用户ID"
    add_index :channels, :shopkeeper_user_id
  end
end
