class AddCreatedAtIndexToIncomeRecord < ActiveRecord::Migration[5.2]
  def change
    add_index :income_records, :created_at
  end
end