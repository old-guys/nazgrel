class AddCreatedAtShopIdIndexToViewJournal < ActiveRecord::Migration[5.1]
  def change
    remove_index :view_journals, :created_at
    add_index :view_journals, [:created_at, :shop_id]
  end
end