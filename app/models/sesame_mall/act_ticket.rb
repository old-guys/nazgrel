class ActTicket < ApplicationRecord

  enum ticket_type: {
    normal: 1,
    deduction_shop: 2
  }
end