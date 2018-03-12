class AddAssetTypeToIncomeRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :income_records, :asset_type, :integer, comment: "记录类型：1.资金流水，2.芝蚂币流水"
  end
end