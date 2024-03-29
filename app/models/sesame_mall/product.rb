class Product < ApplicationRecord
  has_many :product_shops
  belongs_to :category, primary_key: :id,
    foreign_key: :category_id,
    class_name: :Category, required: false

  has_one :product_brand_supplier, primary_key: :id,
    foreign_key: :product_id,
    class_name: :ProductBrandSupplier, required: false

  has_many :product_skus

  delegate :brand, :supplier, to: :product_brand_supplier, allow_nil: true

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