class AddActivationRateToReportShopEcn < ActiveRecord::Migration[5.1]
  def change
    add_column :report_shop_ecns, :descendant_activation_rate, :float, default: 0, comment: "店主激活率: 有交易的所有下级店主数/总下级店主数"
  end
end