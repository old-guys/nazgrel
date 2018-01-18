class AddShopIdCreatedAtIndexToViewJournal < ActiveRecord::Migration[5.1]
  def change
    remove_index :view_journals, :shop_id
    add_index :view_journals, [:shop_id, :created_at]
  end
end