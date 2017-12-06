class ProductShop < ApplicationRecord
  belongs_to :shop, required: false
  belongs_to :product, required: false

  enum status: {
    online: 0,
    offline: 1,
    sold_out: 2,
    has_deleted: 3,
    has_offlined: 20
  }
end
