class CreateBanks < ActiveRecord::Migration[5.1]
  def change
    create_table :banks, comment: "银行" do |t|
      t.string :bank_name, comment: "银行名称"
      t.string :bank_img, comment: "背景图片"
      t.string :bank_log, comment: "银行图标"
      t.integer :delete_status, comment: "有效状态：0-有效，1-无效"

      t.timestamps
    end
  end
end