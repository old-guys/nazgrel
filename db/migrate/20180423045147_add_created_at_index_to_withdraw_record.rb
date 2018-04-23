class AddCreatedAtIndexToWithdrawRecord < ActiveRecord::Migration[5.2]
  def change
    add_index :withdraw_records, :created_at
  end
end