class ShopWechatUser < ApplicationRecord
  enum gender: {
    female: 0,
    male: 1
  }
  enum status: {
    binded: 0,
    unbind: 1
  }
end