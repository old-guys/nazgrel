class CumulativeShopActivity::UpdateReport
  class << self
    def update_report(shops: , report_date: Date.today, touch_report_date: false, force_update: false, interval_time: 30.minutes)
      _records = ReportCumulativeShopActivity.where(
        shop: shops
      ).find_each.to_a

      _time = Time.now

      shops.each {|shop|
        _record = _records.find{|record|
          record.shop_id == shop.id
        }

        if _record.blank?
          _records << ReportCumulativeShopActivity.new(
            shop: shop,
            report_date: report_date
          )
        end
      }

      _records.each {|_record|
        next if not force_update and _record.persisted? and (_record.updated_at + interval_time) >= _time
        logger.info "update report for shop_id: #{_record.shop_id}"

        _record.report_date = Date.today if touch_report_date
        _report = CumulativeShopActivity::UpdateReport.new(
          record: _record,
          date: report_date
        )

        _report.perform
      }
    end

    def insert_to_partial_shops(id: )
      _ids = Array.wrap(id).uniq
      return if _ids.blank?

      _key = CumulativeShopActivity::UpdateReport::SHOP_IDS_CACHE_KEY
      $redis.SADD(_key, _ids)
    end
  end
  include CumulativeShopActivity::Calculations
  include ReportLoggerable

  SHOP_IDS_CACHE_KEY = "shop_cumulative_report_shop_ids"

  attr_accessor :record, :date, :result

  def initialize(record: , date: )
    self.record = record
    self.date = date
  end

  def perform
    begin
      process

      write
    rescue => e
      logger.warn "update report failure #{e}, record: #{record.try(:attributes)}"
    end
  end

  private
  def process
    @result = calculate(shop_id: record.shop_id, date: date)

    record.assign_attributes(
      @result
    )
  end
  def write
    record.changed? ? record.save : record.touch
  end

  private
end