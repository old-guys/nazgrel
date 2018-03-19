class CreateActUserTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :act_user_tickets, comment: "用户领券" do |t|
      t.string :ticket_no, comment: "券的唯一标示ID"
      t.string :user_id, comment: "用户ID"
      t.bigint :ticket_activity_id, comment: "优惠券活动id"
      t.string :name, comment: "优惠券活动+优惠券名称"
      t.datetime :start_time, comment: "开始时间"
      t.datetime :end_time, comment: "结束时间"
      t.integer :ticket_type, default: 1, comment: "1:普通,2:白金会员开店抵扣券，3：黄金会员开店抵扣券"
      t.integer :status, comment: "0:可用,1:已使用,2:冻结失效,3:已转赠"
      t.decimal :amount, precision: 10, scale: 0, comment: "面"
      t.decimal :condition, precision: 10, scale: 0, comment: "使用条件,满多少减amount"
      t.bigint :shop_id, comment: "店铺ID"
      t.string :org_id, comment: "源现金券NO"
      t.bigint :ticket_id, comment: "券ID"

      t.timestamps
    end
    add_index :act_user_tickets, :ticket_activity_id
    add_index :act_user_tickets, :shop_id
    add_index :act_user_tickets, :ticket_id
  end
end