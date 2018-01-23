module ApiKeyable
  extend ActiveSupport::Concern

  included do
    class_attribute :user_id_column

    before_create :generate_access_token
  end

  def keyable_id
    send(user_id_column)
  end

  def delete_api_token_cache
    _value = send(user_id_column)

    $memory_cache.delete(
      self.class.keyable_cache_key_by(access_token: access_token)
    )
    Rails.cache.delete(
      self.class.api_token_cache_key(_value)
    )
  end

  private
  def generate_access_token
    begin
      secure_key = SecureRandom.hex
      self.access_token = Digest::MD5.hexdigest("api_key_#{secure_key}")
    end while self.class.exists?(access_token: access_token)
  end

  module ClassMethods
    def api_key_on(column: )
      self.user_id_column = column

      before_update :delete_api_token_cache
      before_destroy :delete_api_token_cache
    end

    def keyable_cache_key_by(access_token: )
      "#{name}:#{access_token}"
    end

    def api_token_cache_key(value)
      "#{to_s.underscore}:user_id_#{value}"
    end
  end
end