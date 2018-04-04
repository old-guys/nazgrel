class SesameMall::OrderRefundSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :refund_order_no
    self.source_primary_key = :refund_order_no
  end

  def fetch_records(ids: )
    ::OrderRefund.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::OrderRefund.new

    record.assign_attributes(
      refund_order_no: data[:refund_order_no],
      order_no: data[:order_no],

      refund_amount: data[:refund_amount],
      refund_comm: data[:refund_comm],
      refund_virt_coin_reduce_price: data[:refund_virt_coin_reduce_price],

      refund_type: ::OrderRefund.refund_types.invert[data[:refund_type].to_i],
      refund_status: ::OrderRefund.refund_statuses.invert[data[:refund_status].to_i],

      refund_reason: data[:refund_reason],
      refund_detail: data[:refund_detail],
      audit_detail: data[:audit_detail],
      refund_account_name: data[:refund_account_name],

      ref_type: data[:ref_type],
      audit_username: data[:audit_username],
      audit_userid: data[:audit_userid],

      refund_flag: ::OrderRefund.refund_flags.invert[data[:refund_flag].to_i],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:modify_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::OrderRefund)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::OrderRefund, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end