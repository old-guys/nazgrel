class ShopActivityReportWorker
  include Sidekiq::Worker
  include ReportWorkable

  sidekiq_options queue: :report, retry: false, backtrace: true

  def perform(*args)
    logger.info "start: args #{args}"
    options = args.extract_options!
    _type = options["type"] || "partial"
    shops = case _type
      when "whole"
        Shop.where(
          user_id: Shopkeeper.where(
            updated_at: Time.now.all_week,
          ).select(:user_id)
        )
      when "partial"
        _key = ReportShopActivity::UpdateReport::SHOP_IDS_CACHE_KEY

        # FIXME SPOP not accept count argument for redis < 3.2
        # _ids = $redis.SPOP(_key, 50)
        _ids = $redis.SRANDMEMBER(_key, 50)
        $redis.SREM(_key, _ids) if _ids.present?

        Shop.where(id: _ids)
    end

    ReportShopActivity::UpdateReport.update_report(
      shops: shops.preload(:shopkeeper)
    )

    logger.info "finished"
  end

  private
end