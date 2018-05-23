class AddPrejectIdToShopkeeper < ActiveRecord::Migration[5.2]
  def change
    add_column :shopkeepers, :project_id, :bigint, comment: "项目ID"
    add_column :shopkeepers, :project_operation_user, :string, comment: "项目操作人"
    add_column :shopkeepers, :show_shop_id, :string, comment: "店铺展示ID"

    add_index :shopkeepers, :project_id
  end
end
