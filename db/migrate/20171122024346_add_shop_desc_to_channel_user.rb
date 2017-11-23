class AddShopDescToChannelUser < ActiveRecord::Migration[5.1]
  def change
    add_column :channel_users, :shopkeeper_user_id, :integer, comment: "店主用户ID"
    add_index :channel_users, :shopkeeper_user_id
    add_column :channel_users, :shop_id, :integer, comment: "店主ID"
    add_index :channel_users, :shop_id
  end
end
