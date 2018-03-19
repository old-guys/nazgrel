class CreateOrderDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :order_details, comment: "订单详情" do |t|
      t.bigint :order_no, comment: "订单编号"
      t.bigint :sub_order_no, comment: "子订单编号"
      t.bigint :product_sku_id, comment: "商品skuID"
      t.bigint :product_id, comment: "商品ID"
      t.text :product_skuinfo, comment: "商品sku信息"
      t.string :product_name, comment: "商品名称"
      t.string :product_image, comment: "商品图片"
      t.integer :product_num, comment: "商品数量"
      t.decimal :product_market_price, precision: 11, scale: 3, comment: "商品市场价SKU"
      t.decimal :product_sale_price, precision: 11, scale: 3, comment: "商品实际单价SKU"
      t.float :commission_rate, comment: "佣金比例"
      t.integer :is_free_delivery, comment: "是否包邮,0不包邮,1包邮"
      t.decimal :express_price, precision: 11, scale: 3, comment: "快递价格"
      t.bigint :supplier_id, comment: "供应商ID"
      t.integer :activity_id, comment: "活动ID"
      t.integer :product_label_type, comment: "商品类型"
      t.integer :product_group_id, comment: "商品组合编号"
      t.decimal :product_old_sale_price, precision: 11, scale: 3, comment: "原始价格"

      t.timestamps
    end
    add_index :order_details, :order_no
    add_index :order_details, :sub_order_no
    add_index :order_details, :product_id
    add_index :order_details, :supplier_id
  end
end
