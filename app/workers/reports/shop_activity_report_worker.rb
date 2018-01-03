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
              updated_at: Time.now.all_week,
            ).select(:user_id)
          )
        )
      when "partial"
        _key = ShopActivity::UpdateReport::SHOP_IDS_CACHE_KEY

        # FIXME SPOP not accept count argument for redis < 3.2
        # _ids = $redis.SPOP(_key, 100)
        _ids = $redis.SMEMBERS(_key)
        $redis.DEL(_key) if _ids.present?

        _ids.each_slice(500) {|ids|
          ShopActivity::UpdateReport.update_report(
            shops: Shop.preload(:shopkeeper).where(id: _ids)
          )
        }
    end

    logger.info "finished"
  end

  private
end