class CreateIncomeRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :income_records do |t|
      t.bigint :user_id, comment: "用户ID"
      t.decimal :income_amount, precision: 11, scale: 3, comment: "收益金额"
      t.bigint :source_user_id, comment: "来源用户ID"
      t.bigint :source_user_level, comment: "来源用户等级 0：无等级（自己）1：一级 2：二级"
      t.integer :income_type, comment: "收入类型: 1：邀请收入2：团队收入3：佣金收入（店铺佣金）4：消费退单"
      t.integer :record_type, comment: "记录类型：0：收入1：支出"
      t.integer :status, comment: "状态:0：待确认1：已确认"
      t.string :order_id, comment: "订单ID"
      t.integer :syn_asg_flag, comment: "同步爱上岗标志：0：未同步，1：已同步"
      t.string :ticket_no, comment: "抵用券号"
      t.text :remark, comment: "备注"

      t.timestamps
    end
    add_index :income_records, :user_id
    add_index :income_records, :income_type
  end
end
