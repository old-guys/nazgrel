class CreateProjectChannels < ActiveRecord::Migration[5.2]
  def change
    create_table :project_channels, comment: "" do |t|
      t.bigint :channel_no, comment: "渠道ID"
      t.string :channel_name, comment: "渠道名称"
      t.integer :user_num, comment: "店主数"
      t.string :user_grade_remark, comment: "用户等级（0:白金，1：黄金，2：见习）"
      t.string :remark, comment: "备注"
      t.integer :status, comment: "状态 0:有效；1：无效"
      t.string :opt_user, comment: "操作者"

      t.timestamps
    end
  end
end
