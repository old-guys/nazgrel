class AddShopkeeperOrderNumberToShopkeeper < ActiveRecord::Migration[5.1]
  def change
    add_column :shopkeepers, :shopkeeper_order_number, :integer, default: 0, after: :order_number, comment: "自购订单金额"
    add_column :shopkeepers, :shopkeeper_order_amount, :decimal, precision: 11, scale: 3, default: 0, after: :shopkeeper_order_number, comment: "自购订单金额"
    add_column :shopkeepers, :sale_order_number, :integer, default: 0, after: :shopkeeper_order_amount, comment: "销售订单数"
    add_column :shopkeepers, :sale_order_amount, :decimal, precision: 11, scale: 3, default: 0, after: :sale_order_number, comment: "销售订单金额"
  end
end