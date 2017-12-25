class ChannelShopNewerReportWorker
  include Sidekiq::Worker
  include ReportWorkable

  sidekiq_options queue: :report, retry: false, backtrace: true

  def perform(*args)
    logger.info "start: args #{args}"

    ChannelShopNewer::UpdateReport.update_report(
      channels: Channel.normal
    )

    logger.info "finished"
  end

  private
end