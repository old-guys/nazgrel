class CreateActTicketActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :act_ticket_activities, comment: "券活动" do |t|
      t.string :name, comment: "名称"
      t.datetime :start_time, comment: "开始时间"
      t.datetime :end_time, comment: "结束时间"
      t.string :rule, comment: "规则"
      t.integer :ticket_type, comment: "活动类型,1:优惠券活动,2:抵扣券开店活动"
      t.text :description, comment: "描述"
      t.string :status, comment: "1:正常,2:失效"
      t.integer :include_user_group, comment: "0:无效，1:包括，2:排除"

      t.timestamps
    end
  end
end