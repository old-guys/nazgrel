class SesameMall::BankSeek
  include SesameMall::Seekable

  def initialize(opts = {})
  end

  def fetch_records(ids: )
    ::Bank.where(id: ids)
  end

  def to_model(data, record: nil)
    record ||= ::Bank.new

    record.assign_attributes(
      id: data[:id],

      bank_name: data[:bank_name],
      bank_img: data[:bank_img],
      bank_log: data[:bank_log],

      delete_status: data[:delete_status],


      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::Bank)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::Bank, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end