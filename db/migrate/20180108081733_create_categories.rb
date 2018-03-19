class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories, comment: "类别"  do |t|
      t.string :name, comment: "类别名称"
      t.integer :parent_id, comment: "上一级ID"
      t.string :path, comment: "类别层级"
      t.string :desc, comment: "类别描述"
      t.string :level, comment: "级别：\n1000：一级\n2000：二级\n"
      t.string :url, comment: "类别URL"
      t.string :icon, comment: "分类banner图"
      t.string :commission_rate, comment: "佣金比例"

      t.timestamps
    end

    add_index :categories, :name
    add_index :categories, :parent_id
    add_index :categories, :path
  end
end
