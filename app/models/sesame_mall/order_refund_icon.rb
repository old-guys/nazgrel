class OrderRefundIcon < ApplicationRecord
  belongs_to :order_refund, primary_key: :refund_order_no,
    foreign_key: :refund_order_no,
    class_name: :OrderRefund, required: false
end