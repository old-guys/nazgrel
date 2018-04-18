class ProductBrandSupplier < ApplicationRecord
  belongs_to :product, required: false
  belongs_to :brand, required: false
  belongs_to :supplier, required: false
end