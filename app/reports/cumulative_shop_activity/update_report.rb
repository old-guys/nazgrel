class CumulativeShopActivity::UpdateReport
  class << self
    def update_report(shops: , report_date: Date.today, touch_report_date: false, force_update: false, interval_time: 30.minutes)
      _exist_records = ReportCumulativeShopActivity.where(
        shop: shops
      ).find_each.to_a
      _time = Time.now

      _records = shops.map {|shop|
        _record = _exist_records.find{|record|
          record.shop_id == shop.id
        } || ReportCumulativeShopActivity.new(
          shop: shop,
          report_date: report_date
        )
      }

      _records.each_slice(50).map {|records|
        _reports = records.map {|_record|
          next if not force_update and _record.persisted? and (_record.updated_at + interval_time) >= _time
          logger.info "update report for shop_id: #{_record.shop_id}"

          _record.report_date = Date.today if touch_report_date
          _report = CumulativeShopActivity::UpdateReport.new(
            record: _record,
            date: report_date
          )

          _report.perform(skip_save: true)
          _report
        }
        ReportCumulativeShopActivity.transaction do
          _reports.compact.each(&:write)
        end
      }
    end

    def insert_to_partial_shops(id: )
      _ids = Array.wrap(id).uniq
      return if _ids.blank?

      _key = CumulativeShopActivity::UpdateReport::SHOP_IDS_CACHE_KEY
      $redis.SADD(_key, _ids)
    end
  end
  include ReportUpdateable
  include ReportLoggerable

  include CumulativeShopActivity::Calculations
  include ReportCalculationable

  SHOP_IDS_CACHE_KEY = "shop_cumulative_report_shop_ids"

  attr_accessor :record, :date, :result

  def initialize(record: , date: )
    self.record = record
    self.date = date
  end

  private
  def process
    @result = calculate(shop_id: record.shop_id, date: date)

    record.assign_attributes(
      @result
    )
  end
end