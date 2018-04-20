class AddPathAndCreatedAtIndexToShopkeeper < ActiveRecord::Migration[5.2]
  def change
    add_index :shopkeepers, [:path, :created_at]
  end
end