class OrderRefund < ApplicationRecord
  belongs_to :order, primary_key: :order_no,
    foreign_key: :order_no,
    class_name: :Order, required: false

  enum refund_type: {
    good_refund: 0,
    refund: 1
  }
  enum refund_status: {
    awaiting_approve: 0,
    awaiting_sendback: 1,
    awaiting_refund: 2,
    refund_failure: 3,
    refund_success: 4,
    apply_cancel: 5,
    approve_rejected: 6
  }
  enum refund_flag: {
    yes: 1,
    no: 0
  }, _prefix: true
end