class SesameMall::ProjectChannelSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::ProjectChannel.where(id: ids)
  end

  def to_model(data, record: nil)
    record ||= ::ProjectChannel.new

    record.assign_attributes(
      id: data[:id],

      channel_no: data[:channel_no],
      channel_name: data[:channel_name],

      user_num: data[:user_num],
      user_grade_remark: data[:user_grade_remark],

      remark: data[:remark],
      status: data[:status],
      opt_user: data[:opt_user],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::ProjectChannel)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::ProjectChannel, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end
