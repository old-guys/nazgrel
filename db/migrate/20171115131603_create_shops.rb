class CreateShops < ActiveRecord::Migration[5.1]
  def change
    create_table :shops, comment: "店铺" do |t|
      t.string :name, comment: "店名"
      t.integer :user_id, comment: "芝蚂城用户id"

      t.string :path, comment: "店铺邀请层级"
      t.string :channel_path, "代理商层级"

      t.timestamps
    end

    add_index :shops, :user_id
    add_index :shops, :path
    add_index :shops, :channel_path
  end
end
