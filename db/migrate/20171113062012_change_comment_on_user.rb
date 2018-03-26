class ChangeCommentOnUser < ActiveRecord::Migration[5.2]
  def change
    change_table_comment(:users, "用户")
    change_column :users, :email, :string, comment: "邮箱"
    change_column :users, :encrypted_password, :string, comment: "加密密码"
    change_column :users, :reset_password_token, :string, comment: "重置密码 Token"
    change_column :users, :reset_password_sent_at, :datetime, comment: "重置密码发送时间"
    change_column :users, :remember_created_at, :datetime, comment: "记住创建时间"
    change_column :users, :sign_in_count, :integer, comment: "登陆次数"
    change_column :users, :current_sign_in_at, :datetime, comment: "当前登陆时间"
    change_column :users, :last_sign_in_at, :datetime, comment: "上次登陆时间"
    change_column :users, :current_sign_in_ip, :string, comment: "当前登陆ip"
    change_column :users, :last_sign_in_ip, :string, comment: "上次登陆ip"
    change_column :users, :created_at, :datetime, comment: "创建时间"
    change_column :users, :updated_at, :datetime, comment: "更新时间"
    change_column :users, :confirmation_token, :string, comment: "验证 Token"
    change_column :users, :confirmed_at, :datetime, comment: "验证时间"
    change_column :users, :confirmation_sent_at, :datetime, comment: "验证发送时间"
    change_column :users, :unconfirmed_email, :string, comment: "未验证邮箱"
    change_column :users, :failed_attempts, :integer, comment: "失败尝试次数"
    change_column :users, :unlock_token, :string, comment: "解除锁定 Token"
    change_column :users, :locked_at, :datetime, comment: "锁定时间"
    change_column :users, :phone, :string, comment: "手机"
  end
end