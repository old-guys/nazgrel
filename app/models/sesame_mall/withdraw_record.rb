class WithdrawRecord < ApplicationRecord

  enum source: {
    ishangang: 0,
    zmall: 1
  }

  enum status: {
    awaiting_approve: 0,
    approved: 1,
    finished: 2,
    approve_rejected: 3
  }

  enum pay_status: {
    awaiting_transfering: 1,
    rejected: 2,
    transfer_success: 3,
    transfer_failure: 4
  }
end