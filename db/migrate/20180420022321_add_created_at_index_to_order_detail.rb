class AddCreatedAtIndexToOrderDetail < ActiveRecord::Migration[5.2]
  def change
    add_index :order_details, :created_at
  end
end