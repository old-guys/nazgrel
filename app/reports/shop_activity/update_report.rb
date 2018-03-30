class ShopActivity::UpdateReport
  class << self
    def update_report(shops: , report_date: Date.today, force_update: false, interval_time: 30.minutes)
      _records = ReportShopActivity.where(
        shop: shops,
        report_date: report_date
      ).find_each.to_a
      _time = Time.now

      shops.each {|shop|
        _record = _records.find{|record|
          record.shop_id == shop.id
        }

        if _record.blank?
          _records << ReportShopActivity.new(
            shop: shop,
            report_date: report_date
          )
        end
      }

      _recent_records = ReportShopActivity.where(
        shop: shops,
        report_date: report_date.yesterday
      ).find_each.to_a

      _records.each {|_record|
        _recent_record = _recent_records.find{|_recent_record|
          _recent_record.shop_id == _record.shop_id
        }
        _record.shop = shops.find{|s|
          s.id == _record.shop_id
        }

        next if _record.shop.blank?
        next if _record.shop.shopkeeper.blank?

        next if not force_update and _record.persisted? and (_record.updated_at + interval_time) >= _time
        logger.info "update report for shop_id: #{_record.shop_id}"

        _report = ShopActivity::UpdateReport.new(
          recent_record: _recent_record,
          record: _record
        )

        _report.perform
      }
    end

    def insert_to_partial_shops(id: )
      _ids = Array.wrap(id).uniq
      return if _ids.blank?

      _key = ShopActivity::UpdateReport::SHOP_IDS_CACHE_KEY
      $redis.SADD(_key, _ids)
    end
  end
  include ShopActivity::Calculations
  include ReportLoggerable
  include ReportCalculationable

  SHOP_IDS_CACHE_KEY = "shop_activity_report_shop_ids"

  attr_accessor :shop, :date, :recent_record, :record, :result

  def initialize(recent_record: , record: )
    self.recent_record = recent_record
    self.record = record

    self.shop = record.shop
    self.date = record.report_date
  end

  def perform
    begin
      process

      write
    rescue => e
      logger.warn "update report failure #{e}, record: #{record.try(:attributes)}"
      log_error(e)
    end
  end

  private
  def process
    if recent_record.present?
      @result = calculate(shop: shop, date: date, partial_update: true, updated_at: record.updated_at)

      %w(week month year).each {|dimension|
        _result = ReportShopActivity.stat_categories.each_with_object({}) {|category, hash|
          hash[:"#{dimension}_#{category}"] = increase_field_by(field: :"#{category}", unit: dimension)
        }

        @result.merge!(_result)
      }
      %w(total).each {|dimension|
        _result = ReportShopActivity.stat_categories.each_with_object({}) {|category, hash|
          _field = :"#{dimension}_#{category}"

          hash.merge!(
            _field => recent_record.send(_field).to_f + result[category].to_f
          )
        }

        @result.merge!(_result)
      }
    else
      @result = calculate(shop: shop, date: date, partial_update: false, updated_at: record.updated_at)
    end

    record.assign_attributes(
      @result
    )
  end
  def write
    record.has_changes_to_save? ? record.save : record.touch
  end

  private
  def increase_field_by(field: , unit: )
    if record.report_date.in?(recent_record.report_date.send("all_#{unit}"))
      recent_record.send("#{unit}_#{field}").to_f + result[field].to_f
    else
      result[field]
    end
  end
end