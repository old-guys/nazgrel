class InvitePayRecord < ApplicationRecord
  enum pay_way: {
    alipay: 2,
    wechat: 1
  }
  enum pay_status: {
    awaiting_payment: 0,
    success_payment: 1,
    failured: 9
  }
  enum source: {
    create_shop: 0,
    upgrade_shopkeeper_grade: 1,
  }
end