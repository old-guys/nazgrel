class CreateShopUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_users, comment: "用户" do |t|
      t.bigint :user_id, comment: "用户id，爱上岗用户沿用以前ID，芝蚂城根据规则新生成"
      t.string :id_card, comment: "身份证"
      t.string :phone, comment: "手机号"
      t.string :nickname, comment: "昵称"
      t.string :real_name, comment: "真实姓名"
      t.string :user_photo, comment: "用户头像"
      t.integer :age, comment: "年龄"
      t.integer :sex, comment: "性别 0：女，1：男"
      t.date :birthday, comment: "出生年月日"
      t.string :province, comment: "省"
      t.string :city, comment: "市"
      t.string :area, comment: "区"
      t.integer :verify_flag, default: 0, comment: "实名认证标志，0：未实名，1：已实名，2：待审核，3：未通过"
      t.integer :status, default: 0, comment: "0：正常，1：冻结，2：失效"
      t.integer :source, default: 0, comment: "来源：0：爱上岗，1：芝蚂城"
      t.integer :shopkeeper_flag, default: 0, comment: "店主标志：0:否，1：是"
      t.string :wechat_openid, comment: "微信openID"
      t.integer :wechat_flag, default: 0, comment: "是否微信绑定，0：否，1：是"

      t.timestamps
    end
    add_index :shop_users, :user_id
    add_index :shop_users, :id_card
    add_index :shop_users, :phone
  end
end