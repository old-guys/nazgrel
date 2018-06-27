class CreateOrderCollageRels < ActiveRecord::Migration[5.2]
  def change
    create_table :order_collage_rels, comment: "团购用户" do |t|
      t.string :user_id, comment: "用户ID"
      t.string :user_name, comment: "用户名"
      t.string :user_photo, comment: "用户头像"
      t.boolean :is_leader, comment: "0:普通成员,1:团长"
      t.bigint :order_no, comment: "订单ID"
      t.bigint :collage_id, comment: "拼团ID"
      t.boolean :direct_refund, comment: "1:直接退款"
      t.integer :status, comment: "0:待付款,1:等待成团,2:拼团成功,3:已取消,4:退款中,5:已关闭"
      t.integer :refund_status, comment: "0:退款记录生成中,1:退款中,2:退款完成,3:退款失败"
      t.integer :version, comment: "版本号"

      t.timestamps
    end
  end
end
