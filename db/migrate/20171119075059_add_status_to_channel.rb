class AddStatusToChannel < ActiveRecord::Migration[5.1]
  def change
    add_column :channels, :status, :integer, default: 0, null: false
    add_index :channels, :status
  end
end
