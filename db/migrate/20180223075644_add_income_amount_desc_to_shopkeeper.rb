class AddIncomeAmountDescToShopkeeper < ActiveRecord::Migration[5.1]
  def change
    add_column :shopkeepers, :team_income_amount, :decimal, precision: 11, scale: 3, comment: "团队收益"
    add_column :shopkeepers, :shop_sales_amount, :decimal, precision: 11, scale: 3, comment: "销售业绩"
  end
end