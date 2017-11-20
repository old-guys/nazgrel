class Channel < ApplicationRecord
  has_one :channel_user, autosave: true

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

  include ChannelShopable
  include ChannelShopStatusable
  include ChannelOrderable
  include ChannelShopkeeperable

  def to_s
    name
  end
end
