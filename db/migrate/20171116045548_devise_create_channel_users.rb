class DeviseCreateChannelUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :channel_users, comment: "渠道用户" do |t|
      ## Database authenticatable
      t.string :name,               null: false, default: "", comment: "姓名"
      t.string :email,              null: false, default: "", comment: "邮箱"
      t.string :phone,              null: false, default: "", comment: "手机号"
      t.string :encrypted_password, null: false, default: "", comment: "加密密码"

      ## Recoverable
      t.string   :reset_password_token, comment: "重置密码 Token"
      t.datetime :reset_password_sent_at, comment: "重置密码发送时间码"

      ## Rememberable
      t.datetime :remember_created_at, comment: "记住创建时间"

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false, comment: "登陆次数"
      t.datetime :current_sign_in_at, comment: "当前登陆时间"
      t.datetime :last_sign_in_at, comment: "上次登陆时间"
      t.string   :current_sign_in_ip, comment: "当前登陆ip"
      t.string   :last_sign_in_ip, comment: "上次登陆ip"

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false, comment: "失败尝试次数" # Only if lock strategy is :failed_attempts
      t.string   :unlock_token, comment: "解除锁定 Token" # Only if unlock strategy is :email or :both
      t.datetime :locked_at, comment: "锁定时间"

      t.references :channel, foreign_key: true, index: true


      t.timestamps null: false
    end

    add_index :channel_users, :email
    add_index :channel_users, :phone
    add_index :channel_users, :reset_password_token, unique: true
    # add_index :channel_users, :confirmation_token,   unique: true
    add_index :channel_users, :unlock_token,         unique: true
  end
end
