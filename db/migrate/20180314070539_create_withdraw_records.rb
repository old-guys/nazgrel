class CreateWithdrawRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :withdraw_records, comment: "提现记录" do |t|
      t.bigint :user_id, comment: "用户ID"
      t.decimal :amount, precision: 11, scale: 3, comment: "提现金额"
      t.string :order_number, comment: "订单号"
      t.bigint :bank_card_id, comment: "银行卡号ID"
      t.integer :source, comment: "来源  0：爱上岗，1：芝蚂城"
      t.integer :status, comment: "提现状态 0：待审核，1：审核通过，2：已完成，3：审核失败"
      t.integer :pay_status, comment: "财务打款状态： 1:已审核待打款 2:审核失败，拒绝出款 3:出款成功 4:出款失败"
      t.text :remark, comment: "备注"

      t.timestamps
    end
    add_index :withdraw_records, :user_id
    add_index :withdraw_records, :bank_card_id
  end
end