class ChannelRegion < ApplicationRecord
  has_many :channel_users, dependent: :nullify

  has_many :channel_channel_region_maps, dependent: :destroy
  has_many :channels, through: :channel_channel_region_maps

  enum status: {
    normal: 0,
    locked: 1
  }

  include ChannelRegionShopable
  include ChannelRegionShopkeeperable
  include ChannelRegionOrderable
end
