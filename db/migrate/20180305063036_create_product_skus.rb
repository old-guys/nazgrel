class CreateProductSkus < ActiveRecord::Migration[5.2]
  def change
    create_table :product_skus, comment: "产品库存" do |t|
      t.bigint :product_id, comment: "产品ID"
      t.decimal :price, precision: 11, scale: 3, comment: "实际销售价格"
      t.string :sku_n, comment: "SKU识别号（手动输入）"
      t.decimal :sales_price, precision: 11, scale: 3, comment: "优惠价格（暂不用）"
      t.integer :sock_n, comment: "库存"
      t.string :sku_img, comment: "规格图标"
      t.decimal :cost_price, precision: 11, scale: 3, comment: "成本价"
      t.integer :status, default: 10, comment: "10：初始化\n20：营业中\n30：停用"
      t.integer :sales_n, default: 0, comment: "已售数量"
      t.string :sku_info, comment: "SKU 信息(产品规格组合)"
      t.float :commission_rate, comment: "佣金比例"
      t.decimal :market_price, precision: 11, scale: 3, comment: "市场参考价"
      t.integer :is_online, comment: "是否上架"
      t.bigint :version
      t.integer :limit_count, comment: "负数表示不限购"
      t.integer :random_base_n, default: 0, comment: "随机基数：随机选取（11,13,17,19），并将库存按基数翻倍"
      t.integer :stock_random_n, default: 0, comment: "随机基础库存：100到200之间，并加上真实库存数量"
      t.integer :stock_n_ch, default: 0, comment: "wms推送的库存"

      t.timestamps
    end
    add_index :product_skus, :product_id
  end
end