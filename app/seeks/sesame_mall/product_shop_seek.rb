class SesameMall::ProductShopSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :ID
  end

  def fetch_records(ids: )
    ::ProductShop.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::ProductShop.new

    record.assign_attributes(
      id: data[:ID],

      product_id: data[:PRODUCT_ID],
      shop_id: data[:SHOP_ID],

      status: ProductShop.statuses.invert[data[:STATUS].to_i],

      created_at: parse_no_timezone(datetime: data[:CREATE_TIME]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:UPDATE_TIME])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::ProductShop)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::ProductShop, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end