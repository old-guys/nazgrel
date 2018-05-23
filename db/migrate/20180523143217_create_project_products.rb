class CreateProjectProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :project_products, comment: "项目产品" do |t|
      t.bigint :project_id, comment: "项目ID"
      t.bigint :product_id, comment: "商品ID"
      t.integer :status, comment: "状态 1:正常 2:删除"

      t.timestamps
    end
    add_index :project_products, :project_id
    add_index :project_products, :product_id
  end
end
