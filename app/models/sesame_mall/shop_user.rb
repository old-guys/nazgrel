class ShopUser < ApplicationRecord
  has_one :user_card, primary_key: :user_id,
    foreign_key: :user_id,
    class_name: :ShopUserCard, required: false

  enum sex: {
    female: 0,
    male: 1
  }
  enum verify_flag: {
    un_verify: 0,
    approved: 1,
    applying: 2,
    rejected: 3
  }
  enum status: {
    normal: 0,
    locked: 1,
    was_invalid: 2
  }
  enum source: {
    ishanggang: 0,
    sesamemall: 1
  }
  enum shopkeeper_flag: {
    yes: 1,
    no: 0
  }, _prefix: true
  enum wechat_flag: {
    yes: 1,
    no: 0
  }, _prefix: true
end