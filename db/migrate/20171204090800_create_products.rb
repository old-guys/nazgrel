class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products, comment: "商品" do |t|
      t.integer :category_id, comment: "分类ID"
      t.string :opt_user, comment: "操作用户ID"
      t.string :no, comment: "产品编号"
      t.string :name, comment: "产品名称"
      t.text :desc, comment: "产品介绍"
      t.integer :status, default: 10, comment: "状态-10：初始化 20：上架 30：下架 40：失效 "
      t.decimal :price, precision: 11, scale: 3, comment: "市场参考价格"
      t.decimal :max_price, precision: 11, scale: 3, comment: "sku里面最高价格"
      t.decimal :min_price, precision: 11, scale: 3, comment: "sku里面最低价格"
      t.bigint :sale_number, default: 0, comment: "已售数量"
      t.bigint :total_number, default: 0, comment: "上架数量"
      t.bigint :distribution_number, default: 0, comment: "分销数量"
      t.decimal :express_price, precision: 11, scale: 3, comment: "快递价格"
      t.integer :is_pinkage, comment: "是否包邮0:不包邮1；包邮"
      t.string :default_img, comment: "产品默认显示图片"
      t.float :commission_rate, default: 12, comment: "佣金比例"
      t.integer :sort_id, comment: "排序"
      t.integer :label_type, comment: "标签类型-01：普通商品，00：每日爆品，02-店主专享"
      t.integer :top_sort, default: 0, comment: "置顶显示顺序"
      t.string :sper_product_no, comment: "wms物流编号"

      t.timestamps
    end
    add_index :products, :category_id
    add_index :products, :no
    add_index :products, :name
    add_index :products, :sale_number
  end
end
