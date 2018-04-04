class OrderRefundExpress < ApplicationRecord
  belongs_to :order, primary_key: :sub_order_no,
    foreign_key: :order_no,
    class_name: :Order, required: false
end