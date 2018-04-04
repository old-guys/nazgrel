class SesameMall::OrderRefundExpressSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::OrderRefundExpress.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::OrderRefundExpress.new

    record.assign_attributes(
      id: data[:id],
      refund_order_no: data[:refund_order_no],
      order_no: data[:order_no],

      supplier_id: data[:supplier_id],
      supplier_name: data[:supplier_name],

      province: data[:province],
      city: data[:city],
      district: data[:district],
      detail_address: data[:detail_address],

      recv_phone_no: data[:recv_phone_no],
      recv_name: data[:recv_name],

      express_name: data[:express_name],
      express_no: data[:express_no],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:modify_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::OrderRefundExpress)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::OrderRefundExpress, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end