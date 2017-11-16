module ApiKeyable
  extend ActiveSupport::Concern

  included do
    before_create :generate_access_token
    after_commit :delete_api_token_cache, on: :update
  end

  private
  def generate_access_token
    begin
      secure_key = SecureRandom.hex
      self.access_token = Digest::SHA256.base64digest("api_key_#{secure_key}")
    end while self.class.exists?(access_token: access_token)
  end

  def delete_api_token_cache
    cache_key = self.class.api_token_cache_key(user_id)
    Rails.cache.delete(cache_key)
  end

  module ClassMethods
    def api_token_cache_key(user_id)
      "#{to_s}:user_id_#{user_id}"
    end
  end
end
