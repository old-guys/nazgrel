class CreateProductShops < ActiveRecord::Migration[5.1]
  def change
    create_table :product_shops, comment: "店铺代理销售商品" do |t|
      t.bigint :product_id, comment: "商品ID"
      t.bigint :shop_id, comment: "店铺ID"
      t.integer :status, comment: "状态-00：上架(出售中)，01：下架，02：售罄,03：已经删除 20:已下架 "
      t.integer :sort_id, default: 0, comment: "排序编号"

      t.timestamps
    end
    add_index :product_shops, :product_id
    add_index :product_shops, :shop_id
  end
end
