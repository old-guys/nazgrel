class CreateUserAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :user_addresses, comment: "用户收货地址" do |t|
      t.integer :ref, comment: "渠道来源, 微信好友:0,app:1,微信朋友圈:2,qq:3,qq空间:4,短信:5,二维码:6"
      t.string :user_id, comment: "用户ID"
      t.string :province, comment: "省"
      t.string :city, comment: "市"
      t.string :district, comment: "区"
      t.string :detail_address, comment: "详细地址"
      t.string :recv_phone_no, comment: "收件人手机号"
      t.string :recv_user_name, comment: "收件人姓名"
      t.integer :is_default, comment: "是否默认"
      t.integer :is_deleted, comment: "是否删除"

      t.timestamps
    end
  end
end