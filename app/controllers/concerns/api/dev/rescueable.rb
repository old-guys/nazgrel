module Api::Dev::Rescueable
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :rescue_all
    rescue_from Errors::InvalidParameterError, with: :validation_errors
    rescue_from Errors::RecordNotFoundError, with: :record_not_found_error
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  end

  private
  def validation_errors(e)
    log_error(e)
    render json: { code: ErrorCodes::INVALID_PARAMS, message: e.message, remark: e.message, error: e.class.name.underscore }
  end

  def record_not_found_error(e)
    log_error(e)
    render json: { code: ErrorCodes::RECORD_NOT_FOUND, message: e.message, remark: e.message, error: e.class.name.underscore }
  end

  def record_not_found(e)
    log_error(e)
    render json: { code: ErrorCodes::RECORD_NOT_FOUND, message: "您没有权限查看该对象或该对象不存在", remark: "您没有权限查看该对象或该对象不存在", error: e.class.name.underscore, original_message: e.message }
  end

  def record_invalid(e)
    render json: { code: ErrorCodes::UNAUTHORIZED, message: e.record.errors.full_messages.join(", "), remark: e.record.errors.full_messages.join(", ") }
  end

  def rescue_all(e)
    log_error(e)
    render json: { code: ErrorCodes::SERVER_ERROR, message: "抱歉~ 系统出错了，攻城狮们已经在修理了！", remark: "抱歉~ 系统出错了，攻城狮们已经在修理了！", error: e.class.name.underscore, original_message: e.message }
  end

  def log_error(e)
    ErrorLogger.log_error(e, uuid: request.uuid)
    logger.error e.message
  end
end