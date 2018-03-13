class AddUpgradeGradeDescAtToShopkeeper < ActiveRecord::Migration[5.1]
  def change
    add_column :shopkeepers, :order_create_at, :datetime, after: :org_grade, comment: "创建订单时间"
    add_column :shopkeepers, :upgrade_grade_gold_at, :datetime, after: :order_create_at, comment: "升级白金时间"
    add_column :shopkeepers, :upgrade_grade_platinum_at, :datetime, after: :upgrade_grade_gold_at, comment: "升级黄金时间"
  end
end