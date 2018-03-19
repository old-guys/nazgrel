class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles, comment: "角色" do |t|
      t.string :name, comment: "角色名称"

      t.timestamps
    end
  end
end