module ErrorLogger
  def self.logger
    @logger ||= proc {
      _logger = ActiveSupport::Logger.new("#{Rails.root}/log/error.log", "weekly")
      _logger.formatter = Logger::Formatter.new
      _tagged_logger = ActiveSupport::TaggedLogging.new(_logger)
    }.call
  end

  def self.log_error(e, uuid: nil)
    ErrorLogger.logger.error e.message
    error_traces = e.backtrace.select{|l| l.start_with?(Rails.root.to_s)}
    error_traces = e.backtrace if error_traces.blank?

    logger.tagged(uuid) {
      error_traces.each do |message|
        logger.info message
      end
    }
  end
end