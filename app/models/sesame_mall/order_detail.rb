class OrderDetail < ApplicationRecord
  belongs_to :order, primary_key: :order_no,
    foreign_key: :order_no,
    class_name: :Order, required: false

  has_one :order_sub, foreign_key: :sub_order_no, primary_key: :sub_order_no

  belongs_to :product, required: false
  has_one :category, through: :product
  belongs_to :product_sku

  enum is_free_delivery: {
    yes: 1,
    no: 0
  }, _prefix: true
  enum product_label_type: {
    general: 1,
    daily_hot: 0,
    shopkeeper_exclusive: 2,
  }

  scope :hot_sales_product, ->(limit: 5, times: Time.now.all_day, fields: []) {
    fields = fields | [
      Arel.sql("sum(`order_details`.`product_num`) as total_product_num"),
      :product_id
    ]

    joins(:order)
      .merge(Order.valided_order)
      .where(orders: {created_at: times})
      .order(Arel.sql("sum(`order_details`.`product_num`) desc"))
      .group(:product_id)
      .limit(limit)
      .pluck_h(*fields)
  }

end