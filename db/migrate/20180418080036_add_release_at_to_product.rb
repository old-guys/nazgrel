class AddReleaseAtToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :released_at, :datetime, after: :sper_product_no, comment: "上架时间"
    add_column :products, :max_market_price, :decimal, precision: 11, scale: 3, after: :price, comment: "sku里面最大市场价"
    add_column :products, :product_supply, :string, after: :released_at, comment: "货源"
    add_column :products, :purchase_manager, :string, after: :product_supply, comment: "采购经理"
  end
end