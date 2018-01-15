class SesameMall::ViewJournalSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :ID
  end

  def fetch_records(ids: )
    ::ViewJournal.where(id: ids)
  end

  def to_model(data, record: nil)
    record ||= ::ViewJournal.new

    record.assign_attributes(
      id: data[:ID],

      shop_id: data[:SHOP_ID],
      user_id: data[:USER_ID],

      type: ::ViewJournal.types.invert[data[:TYPE].to_i],
      kind: ::ViewJournal.kinds.invert[data[:KIND].to_i],

      viewer_id: data[:VIEWER_ID],

      view_type: ::ViewJournal.view_types.invert[data[:VIEW_type].to_i],

      created_at: parse_no_timezone(datetime: data[:DATE]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::ViewJournal)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::ViewJournal, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end