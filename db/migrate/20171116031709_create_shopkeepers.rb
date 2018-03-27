class CreateShopkeepers < ActiveRecord::Migration[5.2]
  def change
    create_table :shopkeepers, comment: "店主" do |t|
      t.integer :user_id, comment: "爱上岗用户ID"
      t.string :user_name, comment: "用户姓名"
      t.string :user_phone, comment: "用户手机号"
      t.string :user_photo, comment: "用户头像"
      t.integer :user_grade, comment: "店主等级：0-白金店主，1-黄金店主，2-体验店主"
      t.integer :shop_id, comment: "店铺ID"
      t.decimal :total_income_amount, precision: 11, scale: 3, comment: "账户总收入"
      t.decimal :balance_amount, precision: 11, scale: 3, comment: "账户余额"
      t.decimal :withdraw_amount, precision: 11, scale: 3, comment: "已提现金额"
      t.decimal :blocked_amount, precision: 11, scale: 3, comment: "冻结金额"
      t.decimal :invite_amount, precision: 11, scale: 3, comment: "邀请收入"
      t.integer :invite_number, comment: "邀请总人数"
      t.decimal :order_amount, precision: 11, scale: 3, comment: "订单收入"
      t.integer :order_number, comment: "订单总数"
      t.integer :status, comment: "状态0：正常 1：冻结 2：失效"
      t.integer :invite_user_id, comment: "邀请人用户ID"
      t.string :city, comment: "所在城市"
      t.string :province, comment: "所属省份"
      t.string :ticket_no, comment: "抵用券号"
      t.string :parent_user_ids, comment: "用户父级所有ID"
      t.string :path, comment: "店铺邀请用户层级"
      t.datetime :expire_time, comment: "有效期"
      t.integer :use_invite_number, comment: "使用邀请总人数"
      t.integer :org_grade, comment: "店主初始等级"

      t.timestamps
    end
    add_index :shopkeepers, :shop_id
    add_index :shopkeepers, :status
    add_index :shopkeepers, :path
    add_index :shopkeepers, :expire_time
  end
end