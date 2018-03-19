class CreateJoinTablePermissionRoleUser < ActiveRecord::Migration[5.2]
  def change
    create_join_table :permissions, :roles, comment: "权限角色中间表" do |t|
      t.index [:permission_id, :role_id]
      t.index [:role_id, :permission_id]
    end
  end
end