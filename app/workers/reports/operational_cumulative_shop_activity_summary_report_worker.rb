class OperationalCumulativeShopActivitySummaryReportWorker
  include Sidekiq::Worker
  include ReportWorkable

  sidekiq_options queue: :report, retry: false, backtrace: true

  def perform(*args)
    logger.info "start: args #{args}"
    options = args.extract_options!
    _type = options["type"] || "today"

    case _type
      when "today"
        OperationalCumulativeShopActivitySummary::UpdateReport.update_report(
          report_date: Date.today
        )
      when "yesterday"
        OperationalCumulativeShopActivitySummary::UpdateReport.update_report(
          report_date: Date.yesterday,
          force_update: true
        )
    end

    logger.info "finished"
  end

  private
end