class CreatePermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :permissions, comment: "权限"  do |t|
      t.string :name, comment: "名称"
      t.string :subject, comment: "模块"
      t.string :uid, comment: "UID"

      t.timestamps
    end
    add_index :permissions, :uid, unique: true
  end
end