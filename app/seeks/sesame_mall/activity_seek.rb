class SesameMall::ActivitySeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :ID
  end

  def fetch_records(ids: )
    ::Activity.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::Activity.new

    record.assign_attributes(
      id: data[:ID],

      activity_name: data[:ACTIVITY_NAME],
      label: data[:LABEL],
      icon: data[:LCON],

      status: data[:STATUS].to_i,
      activity_type: data[:activity_type].to_i,
      activity_total: data[:ACTIVITY_TOTAL],

      activity_condition: data[:ACTIVITY_CONDITION],
      preferent_amt: data[:PREFERENT_AMT],

      creator: data[:CREATOR],
      modifer: data[:MODIFIER],

      is_all_product: data[:IS_ALL_PRODUCT].to_i,
      commission_rate: data[:COMMISSION_RATE],

      begin_time: parse_no_timezone(datetime: data[:BEGIN_TIME]),
      end_time: parse_no_timezone(datetime: data[:BEGIN_TIME]),

      created_at: parse_no_timezone(datetime: data[:CREATE_TIME]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:UPDATE_TIME])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::Activity)
    end
  end
end