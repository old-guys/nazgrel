class CreateReportDailyShopGradeOperationals < ActiveRecord::Migration[5.2]
  def change
    create_table :report_daily_shop_grade_operationals, comment: "每日店主等级运营报表" do |t|
      t.date :report_date, comment: "报表日期"

      t.integer :grade_trainee_count, comment: "体验店主数"
      t.integer :activation_grade_trainee_count, comment: "转化有效店体验主数"
      t.integer :trainee_upgrade_gold_count, comment: "体验升黄金"
      t.integer :trainee_upgrade_platinum_count, comment: "体验升白金"
      t.integer :gold_upgrade_platinum_count, comment: "黄金升白金"
      t.integer :grade_gold_count, comment: "黄金店主"
      t.integer :grade_platinum_count, comment: "白金店主"
      t.integer :shopkeeper_count, comment: "新增店主数"

      t.timestamps
    end

    add_index :report_daily_shop_grade_operationals, :report_date
  end
end