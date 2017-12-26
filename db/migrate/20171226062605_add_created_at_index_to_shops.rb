class AddCreatedAtIndexToShops < ActiveRecord::Migration[5.1]
  def change
    add_index :shops, :created_at
  end
end