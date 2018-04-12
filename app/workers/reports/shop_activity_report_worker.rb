class ShopActivityReportWorker
  include Sidekiq::Worker
  include ReportWorkable

  sidekiq_options queue: :report, retry: false, backtrace: true

  def perform(*args)
    logger.info "start: args #{args}"
    options = args.extract_options!
    _type = options["type"] || "partial"
    case _type
      when "whole"
        ShopActivity::UpdateReport.update_report(
          shops: Shop.preload(:shopkeeper).where(
            user_id: Shopkeeper.where(
              updated_at: Time.now.all_day,
            ).select(:user_id)
          ),
          interval_time: 8.hours
        )
      when "partial"
        _key = ShopActivity::UpdateReport::SHOP_IDS_CACHE_KEY

        # FIXME SPOP not accept count argument for redis < 3.2
        # _ids = $redis.SPOP(_key, 100)
        _ids = $redis.SMEMBERS(_key)
        $redis.DEL(_key) if _ids.present?

        _ids.each_slice(500) {|ids|
          _shops = Shop.preload(:shopkeeper).where(id: ids)

          ShopActivity::UpdateReport.update_report(
            shops: _shops,
            interval_time: 2.minutes
          )

          CumulativeShopActivity::UpdateReport.insert_to_partial_shops(
            id: _shops.map(&:id)
          )

          CityShopActivity::UpdateReport.insert_to_partial_city(
            city: _shops.map{|record|
              record.shopkeeper.try(:city)
            }.compact.uniq
          )
        }
    end

    logger.info "finished"
  end

  private
end