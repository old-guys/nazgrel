class SesameMall::WithdrawRecordSeek
  include SesameMall::Seekable
  include SesameMall::ShopkeeperTimestampable

  after_process :after_process_record

  def initialize(opts = {})
  end

  def fetch_records(ids: )
    ::WithdrawRecord.where(id: ids)
  end

  def to_model(data, record: nil)
    record ||= ::WithdrawRecord.new

    record.assign_attributes(
      id: data[:id],

      user_id: data[:user_id],

      amount: data[:amount],

      order_number: data[:order_number],
      bank_card_id: data[:bankcard_id],
      source: ::WithdrawRecord.sources.invert[data[:source]],

      status: ::WithdrawRecord.statuses.invert[data[:status]],
      pay_status: ::WithdrawRecord.pay_statuses.invert[data[:pay_status]],

      remark: data[:remark],

      created_at: parse_no_timezone(datetime: data[:create_time]),
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
      target: ::WithdrawRecord
    )

    ::Shopkeeper.insert_to_report_activity_partial_shops(
      records: _shopkeepers
    )
  end
  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::WithdrawRecord)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::WithdrawRecord, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end