class CreateShareJournals < ActiveRecord::Migration[5.2]
  def change
    create_table :share_journals, comment: "店铺分享日志" do |t|
      t.bigint :shop_id, comment: "店铺ID"
      t.bigint :user_id, comment: "用户ID"
      t.integer :type, comment: "分享类型:0-微信好友,1-app,2-微信朋友圈,2-qq好友,4-qq空间,5-手机短信,6-二维码"
      t.integer :share_type, comment: "分享来源类型：00-店铺分享，01-邀请分享"

      t.timestamps
    end
    add_index :share_journals, :shop_id
    add_index :share_journals, :user_id
    add_index :share_journals, :created_at
  end
end