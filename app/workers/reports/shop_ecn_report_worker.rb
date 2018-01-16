class ShopEcnReportWorker
  include Sidekiq::Worker
  include ReportWorkable

  sidekiq_options queue: :report, retry: false, backtrace: true

  def perform(*args)
    logger.info "start: args #{args}"
    options = args.extract_options!
    _type = options["type"] || "partial"
    case _type
      when "whole"
        ShopEcn::UpdateReport.update_report(
          shops: Shop.preload(:channel, shopkeeper: :parent).where(
            user_id: Shopkeeper.where(
              updated_at: Time.now.all_week,
            ).select(:user_id)
          ),
          interval_time: 8.hours
        )
      when "partial"
        _key = ShopEcn::UpdateReport::SHOP_IDS_CACHE_KEY

        # FIXME SPOP not accept count argument for redis < 3.2
        # _ids = $redis.SPOP(_key, 100)
        _ids = $redis.SMEMBERS(_key)
        $redis.DEL(_key) if _ids.present?

        _ids.each_slice(500) {|ids|
          ShopEcn::UpdateReport.update_report(
            shops: Shop.preload(:channel, shopkeeper: :parent).where(id: _ids)
          )
        }
    end

    logger.info "finished"
  end

  private
end