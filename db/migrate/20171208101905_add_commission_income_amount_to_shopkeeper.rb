class AddCommissionIncomeAmountToShopkeeper < ActiveRecord::Migration[5.2]
  def change
    add_column :shopkeepers, :commission_income_amount,
      :decimal, precision: 11, scale: 3, comment: "店铺佣金"
  end
end