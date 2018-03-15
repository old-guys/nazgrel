class IncomeRecord < ApplicationRecord
  belongs_to :order, required: false,
    foreign_key: :order_id, primary_key: :order_no

  belongs_to :shopkeeper, primary_key: :user_id,
    foreign_key: :user_id,
    class_name: :Shopkeeper, required: false

  enum source_user_level: {
    level_blank: 0,
    level_1th: 1,
    level_2th: 2,
  }

  enum income_type: {
    invite_income: 1,
    team_income: 2,
    commission_income: 3,
    withdraw_income: 4,
    chargeback_income: 5
  }

  enum record_type: {
    income: 0,
    expend: 1
  }

  enum asset_type: {
    money: 1,
    sesame_coin: 2
  }

  enum status: {
    awaiting_confirm: 0,
    confirmed: 1
  }
end