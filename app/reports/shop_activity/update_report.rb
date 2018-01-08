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
    end
  end

  private
  def process
    if recent_record.present?
      @result = calculate(shop: shop, date: date, partial_update: true)
      @result.merge!(
        month_shared_count: increase_field_by(field: :shared_count, unit: :month),
        month_view_count: increase_field_by(field: :view_count, unit: :month),

        month_order_number: increase_field_by(field: :order_number, unit: :month),
        month_shopkeeper_order_number: increase_field_by(field: :shopkeeper_order_number, unit: :month),
        month_sale_order_number: increase_field_by(field: :sale_order_number, unit: :month),

        month_order_amount: increase_field_by(field: :order_amount, unit: :month),
        month_shopkeeper_order_amount: increase_field_by(field: :shopkeeper_order_amount, unit: :month),
        month_sale_order_amount: increase_field_by(field: :sale_order_amount, unit: :month),

        month_children_grade_platinum_count: increase_field_by(field: :children_grade_platinum_count, unit: :month),
        month_children_grade_gold_count: increase_field_by(field: :children_grade_gold_count, unit: :month),

        month_ecn_grade_platinum_count: increase_field_by(field: :ecn_grade_platinum_count, unit: :month),
        month_ecn_grade_gold_count: increase_field_by(field: :ecn_grade_gold_count, unit: :month),
      )

      @result.merge!(
        year_shared_count: increase_field_by(field: :shared_count, unit: :year),
        year_view_count: increase_field_by(field: :view_count, unit: :year),

        year_order_number: increase_field_by(field: :order_number, unit: :year),
        year_shopkeeper_order_number: increase_field_by(field: :shopkeeper_order_number, unit: :year),
        year_sale_order_number: increase_field_by(field: :sale_order_number, unit: :year),

        year_order_amount: increase_field_by(field: :order_amount, unit: :year),
        year_shopkeeper_order_amount: increase_field_by(field: :shopkeeper_order_amount, unit: :year),
        year_sale_order_amount: increase_field_by(field: :sale_order_amount, unit: :year),

        year_children_grade_platinum_count: increase_field_by(field: :children_grade_platinum_count, unit: :year),
        year_children_grade_gold_count: increase_field_by(field: :children_grade_gold_count, unit: :year),

        year_ecn_grade_platinum_count: increase_field_by(field: :ecn_grade_platinum_count, unit: :year),
        year_ecn_grade_gold_count: increase_field_by(field: :ecn_grade_gold_count, unit: :year),
      )
    else
      @result = calculate(shop: shop, date: date, partial_update: false)
    end

    record.assign_attributes(
      @result
    )
  end
  def write
    record.changed? && record.save
  end

  private
  def increase_field_by(field: , unit: )
    if recent_record.report_date.send(unit) == record.report_date.send(unit)
      recent_record.send("#{unit}_#{field}") + result[field]
    else
      result[field]
    end
  end
end