class SesameMall::OrderRefundProductDetailSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::OrderRefundProductDetail.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::OrderRefundProductDetail.new

    record.assign_attributes(
      id: data[:id],
      refund_order_no: data[:refund_order_no],
      order_no: data[:order_no],
      sub_order_no: data[:sub_order_no],
      order_detail_id: data[:order_detail_id],

      supplier_id: data[:supplier_id],
      refund_prod_num: data[:refund_prod_num],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:modify_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::OrderRefundProductDetail)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::OrderRefundProductDetail, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end