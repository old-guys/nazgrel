class AddShopRefToChannel < ActiveRecord::Migration[5.2]
  def change
    add_column :channels, :shop_id, :bigint, comment: "店铺ID"
    add_index :channels, :shop_id
  end
end
