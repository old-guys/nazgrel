class CreateReportProductRepurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :report_product_repurchases, comment: "商品复购率报表" do |t|
      t.date :report_date, comment: "商品复购率报表"
      t.datetime :start_at, comment: "开始时间"
      t.datetime :end_at, comment: "结束时间"
      t.bigint :category_id, comment: "产品分类"
      t.integer :online_product_sku_count, comment: "上架SKU数量"
      t.integer :purchase_product_sku_count, comment: "下单SKU数量"
      t.integer :repurchase_product_sku_count, comment: "复购SKU数量"
      t.float :activation_product_rate, comment: "商品活跃率"
      t.float :repurchase_product_rate, comment: "商品复购率"

      t.timestamps
    end
    add_index :report_product_repurchases, :report_date
  end
end