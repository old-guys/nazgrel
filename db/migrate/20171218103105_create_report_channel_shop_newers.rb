class CreateReportChannelShopNewers < ActiveRecord::Migration[5.2]
  def change
    create_table :report_channel_shop_newers, comment: "渠道新增店主数据" do |t|
      t.date :report_date, comment: "报表日期"
      t.bigint :channel_id, comment: "渠道ID"
      t.integer :stage_1_grade_platinum, comment: "00:00-9:00 白金店主数"
      t.integer :stage_1_grade_gold, comment: "00:00-9:00 黄金店主数"
      t.integer :stage_2_grade_platinum, comment: "09:00-18:00 白金店主数"
      t.integer :stage_2_grade_gold, comment: "09:00-18:00 黄金店主数"
      t.integer :stage_3_grade_platinum, comment: "18:00-24:00 白金店主数"
      t.integer :stage_3_grade_gold, comment: "18:00-24:00 黄金店主数"
      t.integer :month_grade_platinum, comment: "本月累计白金店主数"
      t.integer :month_grade_gold, comment: "本月累计黄金店主数"
      t.integer :year_grade_platinum, comment: "本年累计白金店主数"
      t.integer :year_grade_gold, comment: "本年累计黄金店主数"

      t.timestamps
    end
    add_index :report_channel_shop_newers, :report_date
    add_index :report_channel_shop_newers, :channel_id
  end
end