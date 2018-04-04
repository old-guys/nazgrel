class OrderRefundProductDetail < ApplicationRecord
  belongs_to :order, primary_key: :order_no,
    foreign_key: :order_no,
    class_name: :Order, required: false
  belongs_to :order_sub, primary_key: :sub_order_no,
    foreign_key: :sub_order_no,
    class_name: :OrderSub, required: false
  belongs_to :order_detail, primary_key: :id,
    foreign_key: :order_detail_id,
    class_name: :OrderDetail, required: false
  belongs_to :supplier, primary_key: :id,
    foreign_key: :supplier_id,
    class_name: :Supplier, required: false

  belongs_to :order_refund, primary_key: :refund_order_no,
    foreign_key: :refund_order_no,
    class_name: :OrderRefund, required: false
end