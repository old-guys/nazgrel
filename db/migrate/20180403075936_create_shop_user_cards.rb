class CreateShopUserCards < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_user_cards, comment: "用户身份证" do |t|
      t.bigint :user_id, comment: "用户ID"
      t.string :real_name, comment: "真实姓名"
      t.string :id_card, comment: "身份证号码"
      t.string :card_front, comment: "身份证正面图片"
      t.string :card_back, comment: "身份证背面图片"
      t.string :failure_cause, comment: "审核失败原因"

      t.timestamps
    end
  end
end