class SesameMall::CategorySeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :ID
  end

  def fetch_records(ids: )
    ::Category.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::Category.new

    record.assign_attributes(
      id: data[:ID],
      name: data[:NAME],

      parent_id: data[:PARENT_ID],
      level: data[:LEVEL],

      desc: data[:CATEGORY_DESC],
      url: data[:URL],
      icon: data[:ICON],

      commission_rate: data[:COMMISSION_RATE],

      created_at: parse_no_timezone(datetime: data[:CREATE_TIME]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:UPDATE_TIME])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::Category)
    end
  end
end