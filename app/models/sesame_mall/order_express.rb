class OrderExpress < ApplicationRecord
  belongs_to :order_sub, primary_key: :sub_order_no,
    foreign_key: :sub_order_no,
    class_name: :OrderSub, required: false
end