class ChannelUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  belongs_to :channel, required: false
  belongs_to :channel_region, required: false
  has_one :api_key, class_name: "ChannelApiKey", dependent: :destroy

  validates :phone, presence: true, uniqueness: true

  enum role_type: {
    normal_user: 0,
    manager: 1,
    region_manager: 2
  }

  include Searchable

  include ChannelUserShopable
  include ChannelUserShopkeeperable

  include ChannelUserOrderable
  include ChannelUserProductable

  include ChannelUserStatusable

  include ChannelUserRoleable
  include ChannelUserOwnable

  simple_search_on fields: [
    :name, :phone
  ]

  def email_required?
    false
  end

  def to_s
    name
  end

  def api_token
    return @api_token if @api_token.present?

    _cache_key = ChannelApiKey.api_token_cache_key(id)
    @api_token = Rails.cache.fetch(_cache_key, raw: true) do
      _api_key = ChannelApiKey.where(channel_user_id: id).first_or_create
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

    def find_for_access_token(access_token: )
      _api_key_klass = ChannelApiKey
      _cache_key = _api_key_klass.keyable_cache_key_by(access_token: access_token)

      $memory_cache.fetch (_cache_key) {
        joins(:api_key).find_by(
          _api_key_klass.table_name => {
            access_token: access_token
          }
        )
      }
    end
  end
end