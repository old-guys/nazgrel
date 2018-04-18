class CreateBrands < ActiveRecord::Migration[5.2]
  def change
    create_table :brands, comment: "品牌" do |t|
      t.string :no, comment: "品牌编号"
      t.bigint :supplier_id, comment: "关联的供应商ID"
      t.string :cn_name, comment: "品牌名称（中文）"
      t.string :en_name, comment: "品牌名称（英文）"
      t.string :logo, comment: "品牌logo地址"
      t.string :big_logo, comment: "品牌大图"
      t.text :desc, comment: "品牌介绍"
      t.integer :status, comment: "状态(00 解冻 01 冻结)"
      t.string :creator_user_id, comment: "创建人ID"
      t.string :updater_user_id, comment: "更新人ID"
      t.string :freeze_user_id, comment: "冻结人ID"
      t.string :thaw_user_id, comment: "解冻人ID"
      t.datetime :frozen_at, comment: "冻结时间"
      t.datetime :thaw_at, comment: "解冻时间"

      t.timestamps
    end
    add_index :brands, :supplier_id
  end
end