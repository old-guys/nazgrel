class CreateBankCards < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_cards, comment: "银行卡" do |t|
      t.bigint :user_id, comment: "用户ID"
      t.bigint :bank_id, comment: "银行ID"
      t.string :bank_name, comment: "银行名称"
      t.string :card_num, comment: "银行卡卡号"
      t.string :mobile, comment: "银行卡绑定手机号"
      t.string :owner_name, comment: "银行卡持卡人姓名"
      t.integer :card_type, comment: "卡片类型  1:信用卡  2：储蓄卡"
      t.string :card_address, comment: "开户行"
      t.integer :delete_status, comment: "有效状态：0-有效，1-无效"
      t.integer :status, comment: "状态：0：已绑定，1：已解绑"
      t.string :province, comment: "开户行省份"
      t.string :city, comment: "开户行城市"
      t.integer :err_type, comment: "错误：10:开户行错误 20:银行卡号错误 10:银行卡类型错误 10:持卡人姓名错误 "
      t.string :err_tip, comment: "错误提示"

      t.timestamps
    end
    add_index :bank_cards, :user_id
    add_index :bank_cards, :bank_id
  end
end