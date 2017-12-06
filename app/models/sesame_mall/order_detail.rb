class OrderDetail < ApplicationRecord
  belongs_to :order, primary_key: :order_no,
    class_name: :Order, required: false

  enum is_free_delivery: {
    yes: 1,
    no: 0
  }, _prefix: true
  enum product_label_type: {
    general: 1,
    daily_hot: 0,
    shopkeeper_exclusive: 2,
  }
end
