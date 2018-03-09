class AddUpdatedAtIndexToShop < ActiveRecord::Migration[5.1]
  def change
    add_index :shops, :updated_at
  end
end