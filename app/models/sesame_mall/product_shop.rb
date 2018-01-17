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

  class << self
    def prune_old_records
      _products = Product.where(
        status: Product.statuses.slice(:offline, :was_invalid).values
      ).where("updated_at <= ?", 1.months.ago)

      where(product_id: _products.select(:id)).in_batches(of: 10000) {|records|
        records.delete_all

        sleep 0.5
      }
    end
  end
end