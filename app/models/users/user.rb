class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  has_one :api_key

  def api_token
    return @api_token if @api_token.present?

    _cache_key = ApiKey.api_token_cache_key(id)
    @api_token = Rails.cache.fetch(_cache_key, expires_in: 1.hour, raw: true) do
      _api_key = ApiKey.where(user_id: id).first_or_create
      _api_key.access_token
    end
  end
  alias :user_token :api_token

  class << self
    def find_for_database_authentication(warden_conditions)
      with_database_authentication(warden_conditions).first
    end

    def with_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        login_feild = login.include?('@') ? :email : :phone
        conditions[login_feild] = login
      end
      where(conditions)
    end
  end
end
