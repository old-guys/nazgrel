class ActUserTicket < ApplicationRecord

  enum ticket_type: {
    normal: 1,
    platinum_create_shop_deduction: 2,
    gold_create_shop_deduction: 3
  }
  enum status: {
    available: 0,
    used: 1,
    was_invalid: 2,
    was_donated: 3
  }
end