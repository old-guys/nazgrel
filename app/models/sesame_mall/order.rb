class Order < ApplicationRecord
  belongs_to :shop, primary_key: :id,
    foreign_key: :shop_id,
    class_name: :Shop, required: false

  enum order_status: {
    awaiting_payment: 0,
    awaiting_delivery: 1,
    deliveried: 2,
    finished: 3,
    canceled: 4,
    finished_trouble: 5
  }
  enum order_type: {
    create_shop: 0,
    shopkeeper_order: 1,
    third_order: 2
  }
  enum ref_type: {
    wechat_friend: 0,
    app: 1,
    wechat_moment: 2,
    qq: 3,
    qq_zone: 4,
    sms: 5,
    qrcord: 6
  }
  enum comm_setted: {
    yes: 1,
    no: 0
  }, _prefix: true
  enum payed_push: {
    yes: 1,
    no: 0
  }, _prefix: true
  enum global_freight_flag: {
    yes: 1,
    no: 0
  }, _prefix: true
end
