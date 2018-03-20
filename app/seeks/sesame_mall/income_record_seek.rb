class SesameMall::IncomeRecordSeek
  include SesameMall::Seekable
  after_process :after_process_record

  def initialize(opts = {})
  end

  def fetch_records(ids: )
    ::IncomeRecord.where(id: ids)
  end

  def to_model(data, record: nil)
    record ||= ::IncomeRecord.new

    record.assign_attributes(
      id: data[:id],

      user_id: data[:user_id],

      income_amount: data[:income_amount],

      source_user_id: data[:source_user_id],
      source_user_level: ::IncomeRecord.source_user_levels.invert[data[:source_user_level]],

      income_type: ::IncomeRecord.income_types.invert[data[:income_type]],
      record_type: ::IncomeRecord.record_types.invert[data[:type]],
      asset_type: ::IncomeRecord.asset_types.invert[data[:record_type]],
      status: ::IncomeRecord.statuses.invert[data[:status]],

      order_id: data[:order_id],

      syn_asg_flag: data[:syn_asg_flag],
      ticket_no: data[:ticket_no],
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
    ::Shopkeeper.insert_to_report_activity_partial_shops(
      records: records.map(&:shopkeeper)
    )

    process_shopkeeper_commission_amount(records: records)
  end

  def process_shopkeeper_commission_amount(records: )
    _shopkeepers = []
    records.select(&:commission_income?).select(&:confirmed?).each {|record|
      next if record.shopkeeper.nil?

      record.shopkeeper.assign_attributes(
        commission_income_amount: record.shopkeeper.income_records.commission_income.confirmed.
          sum(:income_amount)
      )
      _shopkeepers << record.shopkeeper
    }

    records.select(&:team_income?).select(&:confirmed?).each {|record|
      next if record.shopkeeper.nil?

      record.shopkeeper.assign_attributes(
        team_income_amount: record.shopkeeper.income_records.team_income.confirmed.
          sum(:income_amount)
      )
      _shopkeepers << record.shopkeeper
    }

    ActiveRecord::Base.transaction do
      _shopkeepers.select(&:changed?).map(&:save)
    end
  end
  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::IncomeRecord)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::IncomeRecord, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end