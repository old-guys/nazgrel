class CreateSuppliers < ActiveRecord::Migration[5.2]
  def change
    create_table :suppliers, comment: "供应商" do |t|
      t.string :industry_id, comment: "行业ID"
      t.string :sup_no, comment: "供应商编号"
      t.string :name, comment: "供应商名称"
      t.string :contacts, comment: "供应商联系人"
      t.string :province_id, comment: "省份ID"
      t.string :city_id, comment: "城市ID"
      t.integer :status, comment: "状态(00 解冻 01 冻结)"
      t.integer :phone, comment: "手机号"
      t.integer :address, comment: "地址"
      t.string :url, comment: "网址"
      t.string :logo, comment: "logo"
      t.text :desc, comment: "简介"
      t.string :creator_user_id, comment: "创建人ID"
      t.string :updater_user_id, comment: "更新人ID"
      t.string :freeze_user_id, comment: "冻结人ID"
      t.string :thaw_user_id, comment: "解冻人ID"
      t.datetime :frozen_at, comment: "冻结时间"
      t.datetime :thaw_at, comment: "解冻时间"

      t.timestamps
    end
    add_index :suppliers, :industry_id
  end
end