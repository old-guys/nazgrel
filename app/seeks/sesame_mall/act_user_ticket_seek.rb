class SesameMall::ActUserTicketSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::ActUserTicket.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::ActUserTicket.new

    record.assign_attributes(
      id: data[:id],

      ticket_no: data[:ticket_no],
      user_id: data[:user_id],
      ticket_activity_id: data[:ticket_activity_id],
      name: data[:name],
      start_time:  parse_no_timezone(datetime: data[:start_time]),
      end_time: parse_no_timezone(datetime: data[:end_time]),

      ticket_type: ActUserTicket.ticket_types[data[:type].to_i],
      status: ActUserTicket.statuses[data[:status].to_i],

      amount: data[:amount],
      condition: data[:cond],
      shop_id: data[:shop_id],
      org_id: data[:org_id],
      ticket_id: data[:ticket_id],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::ActUserTicket)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::ActUserTicket, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end