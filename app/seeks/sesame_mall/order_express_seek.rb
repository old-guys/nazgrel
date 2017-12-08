class SesameMall::OrderExpressSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::OrderExpress.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::OrderExpress.new

    record.assign_attributes(
      id: data[:id],
      sub_order_no: data[:sub_order_no],

      express_name: data[:express_name],
      express_no: data[:express_no],

      express_price: data[:express_price],

      created_at: parse_no_timezone(datetime: data[:create_date]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::OrderExpress)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::OrderExpress, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end