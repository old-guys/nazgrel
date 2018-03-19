class CreateJoinTableRoleUser < ActiveRecord::Migration[5.2]
  def change
    create_join_table :roles, :users, comment: "用户角色中间表" do |t|
      t.index [:role_id, :user_id]
      t.index [:user_id, :role_id]
    end
  end
end