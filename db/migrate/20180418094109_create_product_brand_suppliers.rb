class CreateProductBrandSuppliers < ActiveRecord::Migration[5.2]
  def change
    create_table :product_brand_suppliers, comment: "产品品牌供应商关联表" do |t|
      t.bigint :product_id, comment: "产品id"
      t.bigint :brand_id, comment: "品牌id"
      t.bigint :supplier_id, comment: "供应商id"
      t.string :create_operator, comment: "创建人"
      t.string :modify_operator, comment: "更新人"

      t.timestamps
    end
    add_index :product_brand_suppliers, :product_id
    add_index :product_brand_suppliers, :brand_id
    add_index :product_brand_suppliers, :supplier_id

  end
end