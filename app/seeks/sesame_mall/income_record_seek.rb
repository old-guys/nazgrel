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
      source_user_level: data[:source_user_level],

      source_user_level: data[:source_user_level],
      record_type: data[:type],
      status: data[:status],

      order_id: data[:order_id],

      syn_asg_flag: data[:syn_asg_flag],
      ticket_no: data[:ticket_no],
      remark: data[:remark],

      created_at: data[:create_time],
      updated_at: data[:update_time]
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

      _time = Time.now
      _relation = SesameMall::Source::IncomeRecord.where(
        create_time: duration.ago(_time).._time
      )
      seek.do_partial_sync(relation: _relation)
    end
  end
end
