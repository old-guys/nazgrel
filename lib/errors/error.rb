module Errors
  class InvalidParameterError < StandardError; end
  class InvalidAppError < StandardError; end
  class InvalidUserError < StandardError; end
  class AuthError < StandardError; end
  class AuthLockError < StandardError; end

  class UserAuthenticationError < StandardError; end

  class RecordNotFoundError < StandardError; end

  class UnauthorizedError < StandardError; end
end
