class SesameMall::ShareJournalSeek
  include SesameMall::Seekable
  include SesameMall::ShopkeeperTimestampable

  after_process :after_process_record

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :ID
  end

  def fetch_records(ids: )
    ::ShareJournal.where(id: ids)
  end

  def to_model(data, record: nil)
    record ||= ::ShareJournal.new

    record.assign_attributes(
      id: data[:ID],

      shop_id: data[:SHOP_ID],
      user_id: data[:USER_ID],

      type: ::ShareJournal.types.invert[data[:TYPE].to_i],
      share_type: ::ShareJournal.share_types.invert[data[:SHARE_TYPE].to_i],

      created_at: parse_no_timezone(datetime: data[:DATE]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  private
  def after_process_record(records: )
    ActiveRecord::Associations::Preloader.new.preload(
      records, [:shopkeeper]
    )
    _shopkeepers = records.map(&:shopkeeper).compact.uniq
    touch_shopkeeper_timestamp(
      shopkeepers: _shopkeepers,
      target: ::ShareJournal
    )

    ::Shopkeeper.insert_to_report_activity_partial_shops(
      records: _shopkeepers
    )
  end
  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::ShareJournal)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::ShareJournal, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end