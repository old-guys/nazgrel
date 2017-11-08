module ErrorLogger
  def self.logger
    @logger ||= ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new("#{Rails.root}/log/error.log"))
  end

  def self.log_error(e, uuid: nil)
    ErrorLogger.logger.error e.message
    error_traces = e.backtrace.select{|l| l.start_with?(Rails.root.to_s)}
    error_traces = e.backtrace if error_traces.blank?

    logger.tagged(Time.now.strftime('%Y-%m-%d %H:%M:%S.%L'), uuid) {
      error_traces.each do |message|
        logger.info message
      end
    }
  end
end
