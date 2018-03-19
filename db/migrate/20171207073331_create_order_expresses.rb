class CreateOrderExpresses < ActiveRecord::Migration[5.2]
  def change
    create_table :order_expresses, comment: "物流订单" do |t|
      t.bigint :sub_order_no, comment: "子订单编号"
      t.string :express_no, comment: "物流单号"
      t.string :express_name, comment: "物流公司名"
      t.decimal :express_price, precision: 11, scale: 3, comment: "运费"

      t.timestamps
    end
    add_index :order_expresses, :sub_order_no
    add_index :order_expresses, :express_no
  end
end
