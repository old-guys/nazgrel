ActiveSupport::Notifications.subscribe "sql.active_record" do |name, start, finish, id, payload|
  duration = (finish - start) * 1000

  if SERVICES_CONFIG["log_active_record"].to_s == "true"
    _logger = ActiveSupport::Logger.new("#{Rails.root}/log/active_record.log", "weekly")
    _logger.formatter = Logger::Formatter.new
    _tagged_logger = ActiveSupport::TaggedLogging.new(_logger)

    if duration >= 1
      _tagged_logger.tagged(id) {
        _tagged_logger.info "#{payload[:name]} (#{duration.to_i}ms): #{payload[:sql]}"
      }
    end
  end

  if SERVICES_CONFIG["log_active_record_slow"].to_s == "true"
    _slow_logger = ActiveSupport::Logger.new("#{Rails.root}/log/active_record-slow", "weekly")
    _slow_logger.formatter = Logger::Formatter.new
    _tagged_slow_logger = ActiveSupport::TaggedLogging.new(_slow_logger)

    if duration > (SERVICES_CONFIG["log_active_record_slow"] || 5000)
      _tagged_slow_logger.tagged(id) {
        _tagged_slow_logger.info "#{payload[:name]} (#{duration.to_i}ms): #{payload[:sql]}"
      }
    end
  end
end