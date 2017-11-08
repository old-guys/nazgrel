class ApiKey < ApplicationRecord
  belongs_to :user

  before_create :generate_access_token
  after_commit :delete_api_token_cache, on: :update

  def self.api_token_cache_key(user_id)
    "api_token:user_id_#{user_id}"
  end

  private
  def generate_access_token
    begin
      secure_key = SecureRandom.hex
      self.access_token = Digest::SHA256.base64digest("api_key_#{secure_key}")
    end while self.class.exists?(access_token: access_token)
  end

  def delete_api_token_cache
    cache_key = ApiKey.api_token_cache_key(user_id)
    Rails.cache.delete(cache_key)
  end
end
