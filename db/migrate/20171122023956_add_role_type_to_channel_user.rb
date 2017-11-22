class AddRoleTypeToChannelUser < ActiveRecord::Migration[5.1]
  def change
    add_column :channel_users, :role_type, :integer, default: 0, null: false, comment: "角色类型: 0: 普通用户, 1: 管理员"
  end
end
