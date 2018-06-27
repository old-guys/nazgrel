class SesameMall::OrderCollageRelSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::OrderCollageRel.where(id: ids)
  end

  def to_model(data, record: nil)
    record ||= ::OrderCollageRel.new

    record.assign_attributes(
      id: data[:id],

      user_id: data[:user_id],
      user_name: data[:user_name],
      user_photo: data[:user_photo],
      is_leader: data[:is_leader],

      order_no: data[:order_no],
      collage_id: data[:collage_id],
      direct_refund: data[:direct_refund],

      status: data[:status],
      refund_status: data[:refund_status],

      version: data[:version],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::OrderCollageRel)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::OrderCollageRel, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end
