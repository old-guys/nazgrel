class AddCreatedAtShopIdIndexToShareJournal < ActiveRecord::Migration[5.2]
  def change
    remove_index :share_journals, :created_at
    add_index :share_journals, [:created_at, :shop_id]
  end
end