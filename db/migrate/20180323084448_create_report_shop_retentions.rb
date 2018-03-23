class CreateReportShopRetentions < ActiveRecord::Migration[5.2]
  def change
    create_table :report_shop_retentions, comment: "店主留存率报表" do |t|
      t.date :report_date, comment: "报表日期"
      t.datetime :start_at, comment: "开始时间"
      t.datetime :end_at, comment: "结束时间"
      t.integer :shopkeeper_count, comment: "店主数"
      t.integer :activation_shopkeeper_count, comment: "活跃店主数"
      t.integer :retention_shopkeeper_count, comment: "留存店主数"
      t.float :activation_shopkeeper_rate, comment: "店主活跃率"
      t.float :retention_shopkeeper_rate, comment: "店主留存率"

      t.timestamps
    end

    add_index :report_shop_retentions, :report_date
  end
end