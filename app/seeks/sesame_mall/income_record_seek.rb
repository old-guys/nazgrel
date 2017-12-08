class SesameMall::IncomeRecordSeek
  include SesameMall::Seekable

  def initialize(opts = {})
  end

  def fetch_records(ids: )
    ::IncomeRecord.where(id: ids)
  end

  def to_model(data, record: nil)
    record ||= ::IncomeRecord.new

    record.assign_attributes(
      id: data[:id],

      user_id: data[:user_id],

      income_amount: data[:income_amount],

      source_user_id: data[:source_user_id],
      source_user_level: ::IncomeRecord.source_user_levels.invert[data[:source_user_level]],


      income_type: ::IncomeRecord.income_types.invert[data[:type]],
      status: ::IncomeRecord.statuses.invert[data[:status]],

      order_id: data[:order_id],

      syn_asg_flag: data[:syn_asg_flag],
      ticket_no: data[:ticket_no],
      remark: data[:remark],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::IncomeRecord)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::IncomeRecord, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end