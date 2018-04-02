class UserAddress < ApplicationRecord
  enum ref: {
    wechat_friend: 0,
    app: 1,
    wechat_moment: 2,
    qq: 3,
    qq_zone: 4,
    sms: 5,
    qrcord: 6
  }

  enum is_default: {
    yes: 1,
    no: 0
  }, _prefix: true
  enum is_deleted: {
    yes: 1,
    no: 0
  }, _prefix: true
end