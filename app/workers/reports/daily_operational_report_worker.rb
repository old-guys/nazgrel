class DailyOperationalReportWorker
  include Sidekiq::Worker
  include ReportWorkable

  sidekiq_options queue: :report, retry: false, backtrace: true

  def perform(*args)
    logger.info "start: args #{args}"
    DailyOperational::UpdateReport.update_report(
      report_date: Date.today
    )

    logger.info "finished"
  end

  private
end