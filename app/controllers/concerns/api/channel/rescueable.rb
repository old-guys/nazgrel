module Api::Channel::Rescueable
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :rescue_all
    rescue_from Errors::InvalidAppError, with: :invalid_app_error
    rescue_from Errors::UserAuthenticationError, with: :user_authentication_error
    rescue_from Errors::RecordNotFoundError, with: :record_not_found_error
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from Errors::AuthError, with: :auth_error
    rescue_from Errors::AuthLockError, with: :auth_lock_error
    rescue_from Errors::UnauthorizedError, with: :unauthorized_error
    rescue_from Pundit::NotAuthorizedError, with: :unauthorized_error

    rescue_from ActiveRecord::RecordInvalid, with: :show_errors
  end

  private
  def invalid_app_error(e)
    log_error(e)
    logger.error "invalid_app, auth_params=#{auth_params}"
    render json: { code: ErrorCodes::INVALID_APP, message: e.message, error: e.class.name.underscore }
  end

  def user_authentication_error(e)
    log_error(e)
    render json: { code: ErrorCodes::INVALID_USER, message: e.message, error: e.class.name.underscore }
  end

  def validation_errors(e)
    log_error(e)
    render json: { code: ErrorCodes::INVALID_PARAMS, message: e.message, error: e.class.name.underscore }
  end

  def record_not_found_error(e)
    log_error(e)
    render json: { code: ErrorCodes::RECORD_NOT_FOUND, message: e.message, error: e.class.name.underscore }
  end

  def record_not_found(e)
    log_error(e)
    render json: { code: ErrorCodes::RECORD_NOT_FOUND, message: '您没有权限查看该对象或该对象不存在。', error: e.class.name.underscore }
  end

  def auth_error(e)
    log_error(e)
    render json: { code: ErrorCodes::FAIL_AUTH, message: e.message, error: e.class.name.underscore }
  end

  def auth_lock_error(e)
    log_error(e)
    render json: { code: ErrorCodes::AUTH_LOCK, message: e.message, error: e.class.name.underscore }
  end

  def unauthorized_error(e)
    log_error(e)
    render json: { code: ErrorCodes::UNAUTHORIZED, message: e.message, error: e.class.name.underscore }
  end

  def show_errors(exception)
    exception.record.new_record? ? "": exception.record.errors.full_messages.join(", ")
  end

  def rescue_all(e)
    log_error(e)
    render json: { code: ErrorCodes::SERVER_ERROR, message: "抱歉~ 系统出错了，攻城狮们已经在修理了！", error: e.class.name.underscore, original_message: e.message }
  end

  def log_error(e)
    ErrorLogger.log_error(e, uuid: request.uuid)
    logger.error e.message
  end
end
