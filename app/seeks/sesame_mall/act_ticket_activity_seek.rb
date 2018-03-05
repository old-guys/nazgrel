class SesameMall::ActTicketActivitySeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::ActTicketActivity.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::ActTicketActivity.new

    record.assign_attributes(
      id: data[:id],

      name: data[:name],

      start_time:  parse_no_timezone(datetime: data[:start_time]),
      end_time: parse_no_timezone(datetime: data[:end_time]),

      rule: data[:rule],
      ticket_type: ActTicketActivity.ticket_types[data[:type].to_i],
      status: ActTicketActivity.statuses[data[:status].to_i],
      include_user_group: ActTicketActivity.include_user_groups[data[:include_user_group].to_i],

      description: data[:description],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::ActTicketActivity)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::ActTicketActivity, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end