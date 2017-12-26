class ChannelShopNewerReportWorker
  include Sidekiq::Worker
  include ReportWorkable

  sidekiq_options queue: :report, retry: false, backtrace: true

  def perform(*args)
    logger.info "start: args #{args}"
    options = args.extract_options!
    _type = options["type"] || "partial"
    channels = case _type
      when "whole"
        Channel.normal
      when "partial"
        _key = ChannelShopNewer::UpdateReport::CHANNEL_IDS_CACHE_KEY

        # FIXME SPOP not accept count argument for redis < 3.2
        # _ids = $redis.SPOP(_key, 50)
        _ids = $redis.SRANDMEMBER(_key, 50)
        $redis.SREM(_key, _ids) if _ids.present?

        Channel.where(id: _ids)
    end

    ChannelShopNewer::UpdateReport.update_report(
      channels: channels
    )

    logger.info "finished"
  end

  private
end