class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.string :activity_name, comment: "活动名称"
      t.string :label, comment: "活动标签"
      t.string :icon, comment: "活动"
      t.integer :status, comment: "10:初始状态\n20:活动中\n30:已取消"
      t.integer :activity_type, comment: "20:满金额减 30:满件数减"
      t.bigint :activity_total, comment: "总数"
      t.string :activity_condition, comment: "条件"
      t.string :preferent_amt, comment: "减金额"
      t.string :creator, comment: "活动创建人"
      t.string :modifer, comment: "活动修改人"
      t.integer :is_all_product, comment: "10：部分商品\n20：全部商品"
      t.float :commission_rate, comment: "佣金比例"
      t.datetime :begin_time, comment: "活动开始时间"
      t.datetime :end_time, comment: "活动结束时间"

      t.timestamps
    end
  end
end