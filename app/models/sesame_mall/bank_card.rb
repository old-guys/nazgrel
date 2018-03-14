class BankCard < ApplicationRecord
  belongs_to :bank, primary_key: :id,
    required: false

  enum card_type: {
    credit_card: 1,
    debit_card: 2
  }

  enum delete_status: {
    no: 0,
    yes: 1
  }, _prefix: true

  enum status: {
    binded: 0,
    unbind: 1
  }
end