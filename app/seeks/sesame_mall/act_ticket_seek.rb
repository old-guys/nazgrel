class SesameMall::ActTicketSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::ActTicket.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::ActTicket.new

    record.assign_attributes(
      id: data[:id],

      title: data[:title],
      amount: data[:amount],
      condition: data[:condition],
      stock: data[:stock],
      count_per_user: data[:count_per_user],
      sale_count: data[:sale_count],

      usable_day_count: data[:usable_day_count],

      ticket_type: ActTicket.ticket_types[data[:type].to_i],

      image: data[:image],
      image_back_color: data[:image_back_color],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::ActTicket)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::ActTicket, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end