class ShopEcn::UpdateReport
  class << self
    def update_report(shops: , force_update: false, interval_time: 30.minutes)
      _records = ReportShopEcn.where(
        shop: shops
      ).find_each.to_a

      _time = Time.now

      shops.each {|shop|
        _record = _records.find{|record|
          record.shop_id == shop.id
        }

        if _record.blank?
          _records << ReportShopEcn.new(
            shop: shop,
            channel: shop.channel
          )
        end
      }

      _records.each {|_record|
        _record.shop = shops.find{|s|
          s.id == _record.shop_id
        }

        next if _record.shop.blank?
        next if _record.shop.shopkeeper.blank?

        next if not force_update and _record.persisted? and (_record.updated_at + interval_time) >= _time
        logger.info "update report for shop_id: #{_record.shop_id}"

        _report = ShopEcn::UpdateReport.new(
          record: _record
        )

        _report.perform
      }
    end

    def insert_to_partial_shops(id: )
      _ids = Array.wrap(id).uniq
      return if _ids.blank?

      _key = ShopEcn::UpdateReport::SHOP_IDS_CACHE_KEY
      $redis.SADD(_key, _ids)
    end
  end
  include ShopEcn::Calculations
  include ReportLoggerable

  SHOP_IDS_CACHE_KEY = "shop_ecn_report_shop_ids"

  attr_accessor :shop, :record, :result

  def initialize(record: )
    self.record = record

    self.shop = record.shop
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
    @result = calculate(shop: shop)

    record.assign_attributes(
      @result
    )
  end
  def write
    record.changed? ? record.save : record.touch
  end

  private
end