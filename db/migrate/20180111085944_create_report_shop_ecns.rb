class CreateReportShopEcns < ActiveRecord::Migration[5.1]
  def change
    create_table :report_shop_ecns, comment: "店主ECN数据" do |t|
      t.bigint :shop_id, comment: "店铺ID"
      t.bigint :channel_id, comment: "渠道ID"

      t.integer :ecn_count, default: 0, comment: "ECN数"
      t.float :ancestry_rate, default: 0, comment: "上级总数占比"
      t.integer :ecn_grade_platinum_count, default: 0, comment: "ECN白金数"
      t.integer :ecn_grade_gold_count, default: 0, comment: "ECN黄金数"
      t.integer :children_count, default: 0, comment: "直接邀请数"
      t.integer :children_grade_platinum_count, default: 0, comment: "直接ECN白金数"
      t.integer :children_grade_gold_count, default: 0, comment: "直接ECN黄金数"
      t.integer :indirectly_descendant_count, default: 0, comment: "间接邀请数数"
      t.integer :indirectly_descendant_grade_platinum_count, default: 0, comment: "间接ECN白金数"
      t.integer :indirectly_descendant_grade_gold_count, default: 0, comment: "间接ECN黄金数"

      t.timestamps
    end

    add_index :report_shop_ecns, :ecn_count
    add_index :report_shop_ecns, :shop_id
    add_index :report_shop_ecns, :channel_id
  end
end