class SesameMall::OrderRefundPaySeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::OrderRefundPay.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::OrderRefundPay.new

    record.assign_attributes(
      id: data[:id],
      refund_order_no: data[:refund_order_no],
      order_no: data[:order_no],

      serial_number: data[:serial_number],
      refund_amount: data[:refund_amount],

      refund_type: data[:refund_type],
      refund_status: ::OrderRefundPay.refund_statuses.invert[data[:refund_status].to_i],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:modify_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::OrderRefundPay)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::OrderRefundPay, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end