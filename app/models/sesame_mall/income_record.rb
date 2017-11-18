class IncomeRecord < ApplicationRecord

  enum source_user_level: {
    level_blank: 0,
    level_1th: 1,
    level_2th: 2,
  }

  enum income_type: {
    invite_income: 1,
    team_income: 2,
    commission_income: 3,
    chargeback_income: 4
  }

  enum status: {
    awaiting_confirm: 0,
    confirmed: 1
  }
end
