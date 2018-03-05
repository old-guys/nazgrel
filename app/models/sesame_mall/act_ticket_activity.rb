class ActTicketActivity < ApplicationRecord

  enum ticket_type: {
    coupon: 1,
    deduction_shop: 2
  }
  enum status: {
    normal: 1,
    was_invalid: 2
  }, _prefix: true
  enum include_user_group: {
    was_invalid: 0,
    was_included: 1,
    was_excluded: 2
  }
end