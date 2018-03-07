module Export::Loggerable
  extend ActiveSupport::Concern

  included do
    delegate :logger, to: "self.class"
    delegate :log_error, to: "ErrorLogger"

  end

  module ClassMethods
    def logger
      @logger ||= ActiveSupport::TaggedLogging.new(Logger.new("#{Rails.root}/log/export.log", "weekly"))
      if defined?(Sidekiq)
        @logger.formatter = Sidekiq::Logging::Pretty.new
      end

      @logger
    end
  end
end