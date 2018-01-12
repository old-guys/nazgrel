class ReportShopEcn < ApplicationRecord
  belongs_to :shop, required: false
  has_one :shopkeeper, through: :shop

  belongs_to :channel, required: false
  has_one :seek_shop, through: :channel, source: :own_shop
end