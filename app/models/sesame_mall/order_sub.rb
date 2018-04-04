class OrderSub < ApplicationRecord
  belongs_to :order, primary_key: :order_no,
    foreign_key: :order_no,
    class_name: :Order, required: false
  belongs_to :supplier, required: false

  has_one :order_express, foreign_key: :sub_order_no, primary_key: :sub_order_no
  has_many :order_details, foreign_key: :sub_order_no, primary_key: :sub_order_no

  has_many :products, through: :order_details

  enum order_status: {
    awaiting_payment: 0,
    awaiting_delivery: 1,
    deliveried: 2,
    finished: 3,
    canceled: 4,
    finished_trouble: 5
  }
  enum order_sub_status: {
    normal: 0,
    partial_refund: 1,
    all_refund: 2
  }
  enum shop_user_deliveried_push: {
    yes: 1,
    no: 0
  }, _prefix: true
  enum user_deliveried_push: {
    yes: 1,
    no: 0
  }, _prefix: true
  enum supplier_deliveried_push: {
    yes: 1,
    no: 0
  }, _prefix: true
  enum is_zone_freight: {
    yes: 1,
    no: 0
  }, _prefix: true
  enum sync_price: {
    yes: 1,
    no: 0
  }, _prefix: true
  enum delivered_flag: {
    yes: 1,
    no: 0
  }, _prefix: true
end