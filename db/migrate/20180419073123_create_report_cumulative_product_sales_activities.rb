class CreateReportCumulativeProductSalesActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :report_cumulative_product_sales_activities, comment: "累计产品销售报表" do |t|
      t.date :report_date, comment: "报表日期"
      t.bigint :product_id, comment: "产品ID"
      t.decimal :day_7_sales_amount, precision: 11, scale: 3, comment: "7天销售额"
      t.decimal :day_30_sales_amount, precision: 11, scale: 3, comment: "30天销售额"
      t.decimal :day_60_sales_amount, precision: 11, scale: 3, comment: "60天销售额"
      t.decimal :quarter_1_sales_amount, precision: 11, scale: 3, comment: "第1季度销售额"
      t.decimal :quarter_2_sales_amount, precision: 11, scale: 3, comment: "第2季度销售额"
      t.decimal :quarter_3_sales_amount, precision: 11, scale: 3, comment: "第3季度销售额"
      t.decimal :quarter_4_sales_amount, precision: 11, scale: 3, comment: "第4季度销售额"
      t.integer :day_7_sales_count, comment: "7天销量"
      t.integer :day_30_sales_count, comment: "30天销量"
      t.integer :day_60_sales_count, comment: "60天销量"
      t.integer :quarter_1_sales_count, comment: "第1季度销量"
      t.integer :quarter_2_sales_count, comment: "第2季度销量"
      t.integer :quarter_3_sales_count, comment: "第3季度销量"
      t.integer :quarter_4_sales_count, comment: "第4季度销量"

      t.timestamps
    end
    add_index :report_cumulative_product_sales_activities, :report_date
    add_index :report_cumulative_product_sales_activities, :product_id
  end
end