class ReportCumulativeShopActivity < ApplicationRecord
  belongs_to :shop, required: false
  has_one :shopkeeper, through: :shop

  include ReportCumulativeShopActivityable

  class << self
  end
end