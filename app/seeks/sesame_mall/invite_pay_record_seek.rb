class SesameMall::InvitePayRecordSeek
  include SesameMall::Seekable

  after_process :invite_pay_record

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::InvitePayRecord.where(id: ids)
  end

  def to_model(data, record: nil)
    record ||= ::InvitePayRecord.new

    record.assign_attributes(
      id: data[:id],

      order_no: data[:order_no],
      user_phone: data[:user_phone],
      user_id: data[:user_id],
      pay_order_number: data[:pay_order_number],
      invite_id: data[:invite_id],
      pay_amount: data[:pay_amount],

      pay_way: ::InvitePayRecord.pay_ways.invert[data[:pay_way].to_i],
      pay_status: ::InvitePayRecord.pay_statuses.invert[data[:pay_status].to_i],
      source: ::InvitePayRecord.sources.invert[data[:source].to_i],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  private
  def invite_pay_record(records: )
    ActiveRecord::Base.transaction do
      records.select(&:success_payment?).select(&:create_shop?).each {|record|
        ::Shopkeeper.where(user_id: record.user_id).update_all(
          create_shop_amount: record.pay_amount
        ) if record.user_id.to_i > 0
      }

      records.select(&:success_payment?).select(&:upgrade_shopkeeper_grade?).each {|record|
        _shopkeeper = ::Shopkeeper.find_by(user_id: record.user_id)
        _source_shopkeeper = SesameMall::Source::Shopkeeper.find_by(user_id: record.user_id)
        next if _shopkeeper.blank? or _source_shopkeeper.blank?

        _shopkeeper.update(upgrade_grade_platinum_at: record.created_at) if _source_shopkeeper.user_grade == 0
        _shopkeeper.update(upgrade_grade_gold_at: record.created_at) if _source_shopkeeper.user_grade == 1
      }
    end
  end
  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::InvitePayRecord)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::InvitePayRecord, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end