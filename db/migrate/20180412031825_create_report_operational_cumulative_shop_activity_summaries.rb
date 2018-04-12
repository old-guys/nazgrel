class CreateReportOperationalCumulativeShopActivitySummaries < ActiveRecord::Migration[5.2]
  def change
    create_table :report_operational_cumulative_shop_activity_summaries, comment: "运营店主活跃汇总报表" do |t|
      t.date :report_date

      t.integer :week_1_total_count, comment: "1周总店主"
      t.integer :month_1_total_count, comment: "1月总店主"
      t.integer :month_3_total_count, comment: "3月总店主"
      t.integer :month_6_total_count, comment: "6月总店主"
      t.integer :year_1_total_count, comment: "1年总店主"

      t.integer :week_1_grade_gold_count, comment: "1周黄金店主"
      t.integer :month_1_grade_gold_count, comment: "1月黄金店主"
      t.integer :month_3_grade_gold_count, comment: "3月黄金店主"
      t.integer :month_6_grade_gold_count, comment: "6月黄金店主"
      t.integer :year_1_grade_gold_count, comment: "1年黄金店主"

      t.integer :week_1_grade_platinum_count, comment: "1周白金店主"
      t.integer :month_1_grade_platinum_count, comment: "1月白金店主"
      t.integer :month_3_grade_platinum_count, comment: "3月白金店主"
      t.integer :month_6_grade_platinum_count, comment: "6月白金店主"
      t.integer :year_1_grade_platinum_count, comment: "1年白金店主"

      t.integer :week_1_grade_trainee_count, comment: "1周体验店主"
      t.integer :month_1_grade_trainee_count, comment: "1月体验店主"
      t.integer :month_3_grade_trainee_count, comment: "3月体验店主"
      t.integer :month_6_grade_trainee_count, comment: "6月体验店主"
      t.integer :year_1_grade_trainee_count, comment: "1年体验店主"

      t.timestamps
    end
    add_index :report_operational_cumulative_shop_activity_summaries, :report_date, name: "index_report_on_report_date"
  end
end