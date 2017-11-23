class Channel < ApplicationRecord
  has_many :channel_users, autosave: true, dependent: :destroy

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
  include ChannelOrderable
  include ChannelShopkeeperable

  def to_s
    name
  end
end
