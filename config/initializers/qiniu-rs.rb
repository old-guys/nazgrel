require 'qiniu'

QINIU_CONFIG = HashWithIndifferentAccess.new(SERVICES_CONFIG["qiniu"])

Qiniu.establish_connection! access_key: QINIU_CONFIG[:access_key], secret_key: QINIU_CONFIG[:secret_key]

def qiniu_upload_token
  Qiniu.generate_upload_token scope: QINIU_CONFIG[:bucket]
end