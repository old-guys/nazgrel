module ErrorCodes
  UNAUTHORIZED = 401 # 无权限
  METHOD_NOT_ALLOWED = 405 # http请求错误
  SERVER_ERROR = 500 # 服务器内部错误

  RECORD_NOT_FOUND = 100100 # 记录不存

  FAIL_AUTH = 100400 # 认证失败

  INVALID_APP = 100000 # access_token 错误
  INVALID_PARAMS = 100406 # 非法参数
  INVALID_USER = 100401 # 无效用户
end
