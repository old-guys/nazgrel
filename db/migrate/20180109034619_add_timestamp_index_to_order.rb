class AddTimestampIndexToOrder < ActiveRecord::Migration[5.2]
  def change
    add_index :orders, :finish_time
    add_index :orders, :created_at
  end
end