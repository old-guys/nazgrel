class OrderPay < ApplicationRecord
  belongs_to :order, primary_key: :order_no,
    foreign_key: :order_no,
    class_name: :Order, required: false

  enum pay_status: {
    awaiting_payment: 0,
    payment_finished: 1
  }
end