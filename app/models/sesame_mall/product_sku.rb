class ProductSku < ApplicationRecord
  belongs_to :product, required: false

  delegate :brand, :supplier, to: :product, allow_nil: true

  enum status: {
    init: 10,
    opening: 20,
    disabled: 30,
  }
  enum is_online: {
    yes: 1,
    no: 0
  }, _prefix: true

  scope :higher_stock_sales_rate, ->(rate: 0.9) {
    where(
      "`product_skus`.`sales_n` / `product_skus`.`sock_n` >= ?", rate
    )
  }

  def stock_sales_rate
    (sales_n / sock_n.to_f).round(3) rescue nil
  end
end