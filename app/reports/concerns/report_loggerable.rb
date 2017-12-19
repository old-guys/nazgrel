module ReportLoggerable
  extend ActiveSupport::Concern

  included do
    delegate :logger, to: "self.class"
  end

  module ClassMethods
    def logger
      @logger ||= ActiveSupport::TaggedLogging.new(Logger.new("#{Rails.root}/log/report.log", "weekly"))
      if defined?(Sidekiq)
        @logger.formatter = Sidekiq::Logging::Pretty.new
      end

      @logger
    end
  end
end