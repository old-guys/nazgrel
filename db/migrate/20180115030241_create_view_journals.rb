class CreateViewJournals < ActiveRecord::Migration[5.2]
  def change
    create_table :view_journals, comment: "店铺浏览日志" do |t|
      t.bigint :shop_id, comment: "店铺ID"
      t.bigint :user_id, comment: "用户ID"
      t.integer :type, comment: "分享类型:0-微信好友,1-app,2-微信朋友圈,3-qq好友,4-qq空间,5-手机短信,6-二维码"
      t.integer :kind, comment: "浏览位置：00店铺(访客次数)，01商品，（00+01=浏览次数）"
      t.string :viewer_id, comment: "浏览人ID"
      t.integer :view_type, comment: "浏览来源：00-店铺，01-邀请"

      t.timestamps
    end
    add_index :view_journals, :shop_id
    add_index :view_journals, :user_id
    add_index :view_journals, :created_at
  end
end