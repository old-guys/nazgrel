class CreateShopWechatUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_wechat_users, comment: "微信用户" do |t|
      t.bigint :user_id, comment: "用户id"
      t.string :openid, comment: "微信用户对应微信应用的唯一标识"
      t.string :headimgurl, comment: "用户微信头像"
      t.string :nickname, comment: "用户微信名字"
      t.string :province, comment: "省份"
      t.string :city, comment: "城市"
      t.string :country, comment: "国家"
      t.integer :gender, comment: "1:男 0:女"
      t.string :unionid, comment: "开放平台下的 unionid;"
      t.string :appid, comment: "公众号的 appid"
      t.string :mobile, comment: "用户手机号"
      t.integer :status, default: 0, comment: "0:已绑定，1：已解绑"

      t.timestamps
    end
    add_index :shop_wechat_users, :user_id
    add_index :shop_wechat_users, :openid
    add_index :shop_wechat_users, :mobile
  end
end