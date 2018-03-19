class AddCoinDescToShopkeeper < ActiveRecord::Migration[5.2]
  def change
    add_column :shopkeepers, :total_income_coin, :decimal, default: 0, after: :blocked_amount, precision: 11, scale: 3, comment: "总收入芝蚂币"
    add_column :shopkeepers, :balance_coin, :decimal, default: 0, after: :total_income_coin, precision: 11, scale: 3, comment: "芝蚂币余额"
    add_column :shopkeepers, :use_coin, :decimal, default: 0, after: :balance_coin, precision: 11, scale: 3, comment: "已使用芝蚂币"
  end
end