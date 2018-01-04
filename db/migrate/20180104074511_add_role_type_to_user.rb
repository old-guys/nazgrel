class AddRoleTypeToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :role_type, :integer, default: 0, null: false, comment: "角色类型: 0: 后台管理员, 1: 开放平台管理员"
  end
end