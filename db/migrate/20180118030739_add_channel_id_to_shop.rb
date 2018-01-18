class AddChannelIdToShop < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :channel_id, :bigint, comment: "所属渠道ID"
    add_index :shops, :channel_id
  end
end