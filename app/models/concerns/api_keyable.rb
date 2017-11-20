module ApiKeyable
  extend ActiveSupport::Concern

  included do
    class_attribute :user_id_column

    before_create :generate_access_token
  end


  def delete_api_token_cache(value: nil)
    value ||= send(user_id_column)
    _cache_key = self.class.api_token_cache_key(value)

    Rails.cache.delete(_cache_key)
  end

  private
  def generate_access_token
    begin
      secure_key = SecureRandom.hex
      self.access_token = Digest::SHA256.base64digest("api_key_#{secure_key}")
    end while self.class.exists?(access_token: access_token)
  end

  module ClassMethods
    def api_key_on(column: )
      self.user_id_column = column

      after_commit :delete_api_token_cache, on: :update
    end

    def api_token_cache_key(value)
      "#{to_s.underscore}:user_id_#{value}"
    end
  end
end
