class OrderRefundExpress < ApplicationRecord
  belongs_to :order, primary_key: :order_no,
    foreign_key: :order_no,
    class_name: :Order, required: false
  belongs_to :order_refund, primary_key: :refund_order_no,
    foreign_key: :refund_order_no,
    class_name: :OrderRefund, required: false
end