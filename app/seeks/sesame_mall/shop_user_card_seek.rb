class SesameMall::ShopUserCardSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::ShopUserCard.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::ShopUserCard.new

    record.assign_attributes(
      id: data[:id],

      user_id: data[:user_id],
      real_name: data[:real_name],
      idcard: data[:id_card],
      card_front: data[:card_front],
      card_back: data[:card_back],

      failure_cause: data[:failure_cause],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::ShopUserCard)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::ShopUserCard, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end