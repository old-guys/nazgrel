module UserSecureTokenable
  extend ActiveSupport::Concern

  included do
  end

  def temp_access_token
    "user_#{self.id}_temp_access_token"
    #Rails.cache.fetch("user-#{self.id}-temp_access_token-#{Time.now.strftime("%Y%m%d")}") do
    #  SecureRandom.hex
    #end
  end

  def secure_access_token_with(salt = "base", expires_in = 300)
    secure_key = %Q{#{salt}_#{Time.now.to_i / expires_in}}

    Digest::SHA256.base64digest(Digest::SHA1.hexdigest("user_#{self.id}_#{secure_key}"))
  end

  module ClassMethods
    def secure_access_token_with(salt = "base", expires_in = 300)
      secure_key = %Q{#{salt}_#{Time.now.to_i / expires_in}}

      Digest::SHA256.base64digest(Digest::SHA1.hexdigest("#{secure_key}"))
    end
  end
end
