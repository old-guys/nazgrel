class Product < ApplicationRecord
  has_many :product_shops

  enum status: {
    init: 10,
    online: 20,
    offline: 30,
    was_invalid: 40
  }
  enum is_pinkage: {
    yes: 1,
    no: 0
  }, _prefix: true
  enum label_type: {
    general: 1,
    daily_hot: 0,
    shopkeeper_exclusive: 2,
  }

  include Searchable

  simple_search_on fields: [
    :name
  ]

  def to_s
    name
  end
end
