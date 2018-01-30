module ChannelShopable
  extend ActiveSupport::Concern

  included do
    belongs_to :own_shop, class_name: "Shop",
      foreign_key: :shop_id, required: false

    belongs_to :own_shopkeeper, class_name: "Shopkeeper",
      foreign_key: :shopkeeper_user_id, primary_key: :user_id, required: false

    has_many :own_shops, class_name: "Shop"

    after_create if: :shop_id do
      set_shops_channel_path
    end

    alias :shops :own_shops
  end

  # this channel invite shops was channel own shop
  def channel_shops
    @_channel_shops ||= own_shop.descendant_entities.where.
      not(channel_id: nil).where.
      not(channel_id: id)
  end

  def channel_shop_ids
    @channel_shop_ids ||= channel_shops.pluck(:id)
  end

  def shop_ids
    @shop_ids ||= shops.pluck(:id)
  end

  def set_shops_channel_path
    _records = own_shop.self_and_descendant_entities.find_each.map {|record|
      record.set_channel_path
      record
    }

    Shop.transaction do
      _records.each(&:save)
    end
  end

  module ClassMethods
    def normal_channel_shop_ids
      _result = Rails.cache.fetch("#{Channel.normal.cache_key}:channel_shop_ids", raw: true) {
        pluck(:shop_id).to_yaml
      }

      YAML.load(_result)
    end
  end
end