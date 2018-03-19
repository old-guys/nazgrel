class CreateInvitePayRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :invite_pay_records, comment: "邀请支付记录" do |t|
      t.bigint :order_no, comment: "订单编号"
      t.string :user_phone, comment: "用户手机号码"
      t.string :pay_order_number, comment: "支付订单号"
      t.bigint :invite_id, comment: "邀请id"
      t.integer :pay_way, comment: "支付方式：1:微信，2：支付宝"
      t.decimal :pay_amount, precision: 11, scale: 3, comment: "支付金额"
      t.integer :pay_status, comment: "支付状态：0：未支付，1：已支付，9：支付失败"
      t.integer :source, comment: "来源：0:开店，1：店主升级"
      t.bigint :user_id, comment: "用户id"

      t.timestamps
    end
  end
end