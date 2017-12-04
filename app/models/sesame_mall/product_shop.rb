class ProductShop < ApplicationRecord
  enum status: {
    online: 0,
    offline: 1,
    sold_out: 2,
    has_deleted: 3,
    has_offlined: 20
  }
end
