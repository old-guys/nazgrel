class ProductSku < ApplicationRecord

  enum status: {
    init: 10,
    opening: 20,
    disabled: 30,
  }
  enum is_online: {
    yes: 1,
    no: 0
  }, _prefix: true
end