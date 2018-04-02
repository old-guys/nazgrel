class SesameMall::OrderPaySeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::OrderPay.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::OrderPay.new

    record.assign_attributes(
      id: data[:id],
      order_no: data[:order_no],

      serial_number: data[:serial_number],
      pay_price: data[:pay_price],

      pay_type: data[:pay_type],
      pay_status: ::OrderPay.pay_statuses.invert[data[:pay_status].to_i],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:modify_time])
    )

    record
  end

  private
  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::OrderPay)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::OrderPay, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end