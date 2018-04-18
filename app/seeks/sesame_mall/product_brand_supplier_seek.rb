class SesameMall::ProductBrandSupplierSeek
  include SesameMall::Seekable

  def initialize(opts = {})
  end

  def fetch_records(ids: )
    ::ProductBrandSupplier.where(id: ids)
  end

  def to_model(data, record: nil)
    record ||= ::ProductBrandSupplier.new

    record.assign_attributes(
      id: data[:id],

      product_id: data[:prod_id],
      brand_id: data[:brand_id],
      supplier_id: data[:supplier_id],

      create_operator: data[:create_operator],
      modify_operator: data[:modify_operator],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:modify_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::ProductBrandSupplier)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::ProductBrandSupplier, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end