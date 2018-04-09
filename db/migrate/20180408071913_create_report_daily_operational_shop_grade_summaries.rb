class CreateReportDailyOperationalShopGradeSummaries < ActiveRecord::Migration[5.2]
  def change
    create_table :report_daily_operational_shop_grade_summaries, comment: "每日运营店主等级汇总报表" do |t|
      t.date :report_date, comment: "报表日期"
      t.integer :total_grade_gold_count, comment: "累计黄金店主数"
      t.integer :grade_gold_count, comment: "黄金店主数"
      t.integer :activation_grade_gold_count, comment: "活跃黄金店主"
      t.integer :grade_gold_order_number, comment: "黄金店主订单数"
      t.decimal :grade_gold_order_amount, precision: 11, scale: 3, comment: "黄金店主订单金额"
      t.decimal :grade_gold_sale_order_amount, precision: 11, scale: 3, comment: "黄金店主销售订单金额"
      t.decimal :grade_gold_shopkeeper_order_amount, precision: 11, scale: 3, comment: "黄金店主自购订单金额"
      t.float :grade_gold_sale_order_amount_rate, comment: "黄金店主销售订单占比"
      t.float :grade_gold_shopkeeper_order_amount_rate, comment: "黄金店主自购订单占比"
      t.integer :total_grade_platinum_count, comment: "累计白金店主数"
      t.integer :grade_platinum_count, comment: "白金店主数"
      t.integer :activation_grade_platinum_count, comment: "活跃白金店主"
      t.integer :grade_platinum_order_number, comment: "白金店主订单数"
      t.decimal :grade_platinum_order_amount, precision: 11, scale: 3, comment: "白金店主订单金额"
      t.decimal :grade_platinum_sale_order_amount, precision: 11, scale: 3, comment: "白金店主销售订单金额"
      t.decimal :grade_platinum_shopkeeper_order_amount, precision: 11, scale: 3, comment: "白金店主自购订单金额"
      t.float :grade_platinum_sale_order_amount_rate, comment: "白金店主销售订单占比"
      t.float :grade_platinum_shopkeeper_order_amount_rate, comment: "白金店主自购订单占比"
      t.integer :total_grade_trainee_count, comment: "累计体验店主数"
      t.integer :grade_trainee_count, comment: "体验店主数"
      t.integer :activation_grade_trainee_count, comment: "活跃体验店主"
      t.integer :grade_trainee_order_number, comment: "体验店主订单数"
      t.decimal :grade_trainee_order_amount, precision: 11, scale: 3, comment: "体验店主订单金额"
      t.decimal :grade_trainee_sale_order_amount, precision: 11, scale: 3, comment: "体验店主销售订单金额"
      t.decimal :grade_trainee_shopkeeper_order_amount, precision: 11, scale: 3, comment: "体验店主自购订单金额"
      t.float :grade_trainee_sale_order_amount_rate, comment: "体验店主销售订单占比"
      t.float :grade_trainee_shopkeeper_order_amount_rate, comment: "体验店主自购订单占比"

      t.timestamps
    end

    add_index :report_daily_operational_shop_grade_summaries, :report_date, name: "index_report_on_report_date"
  end
end