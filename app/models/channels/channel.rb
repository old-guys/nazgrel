class Channel < ApplicationRecord
  has_many :channel_users, -> { where.not(role_type: ChannelUser.role_types[:region_manager]) }, autosave: true, dependent: :destroy
  has_many :channel_channel_region_maps, dependent: :destroy

  enum category: {
    seed_shopkeeper: 0,
    first_agent: 1,
    channel_manager: 2,
    operator_manager: 3
  }
  enum source: {
    always: 0,
    weichaishi: 1,
    other: 2
  }
  enum status: {
    normal: 0,
    locked: 1
  }

  include Searchable

  include ChannelShopable
  include ChannelShopkeeperable
  include ChannelOrderable
  include ChannelProductable

  include ChannelStatusable

  include ChannelChannelUserable

  simple_search_on fields: [
    :name
  ]

  def to_s
    name
  end
end