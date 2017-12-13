module SesameMall::SeekLoggerable
  extend ActiveSupport::Concern

  included do
    attr_accessor :logger

    def logger
      @logger ||= ActiveSupport::TaggedLogging.new(Logger.new("#{Rails.root}/log/seek.log", "weekly"))
      if defined?(Sidekiq)
        @logger.formatter = Sidekiq::Logging::Pretty.new
      end

      @logger
    end
  end

  module ClassMethods
  end
end