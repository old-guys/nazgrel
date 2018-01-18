class AddShopIdCreatedAtIndexToShareJournal < ActiveRecord::Migration[5.1]
  def change
    remove_index :share_journals, :shop_id
    add_index :share_journals, [:shop_id, :created_at]
  end
end