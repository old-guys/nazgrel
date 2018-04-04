class OrderRefundPay < ApplicationRecord
  belongs_to :order, primary_key: :order_no,
    foreign_key: :order_no,
    class_name: :Order, required: false

  enum refund_status: {
    awaiting_refund: 0,
    refund_success: 1,
    refund_failure: 2,
    refund_cancel: 3
  }
end