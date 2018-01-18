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
  end

  # this channel invite shops was channel own shop
  def channel_shops
    @_channel_shops ||= Shop.joins(:channel).
      descendant_entities(
        own_shop,
        column: :channel_path
      ).where(
        id: self.class.normal_channel_shop_ids
      )
  end

  def channel_shop_ids
    @channel_shop_ids ||= proc {
      _result = Rails.cache.fetch("#{cache_key}:#{Channel.normal.cache_key}:channel_shop_ids", raw: true) {
        channel_shops.pluck(:id).to_yaml
      }

      YAML.load(_result)
    }.call
  end

  def descendant_channel_shops
    return Shop.none if channel_shop_ids.blank?
    _root_shops = Shop.where(id: channel_shop_ids).to_a

    Shop.where(
      _root_shops.map{|shop|
        Utility.where_sql_str(Shop.self_and_descendant_entities(shop, column: :channel_path))
      }.join(" OR ")
    )
  end

  def self_and_descendant_shops
    @self_and_descendant_shops ||= proc {
      _shops = Shop.self_and_descendant_entities(own_shop, column: :channel_path)
      if channel_shop_ids.present?
        _shops = _shops.where.not(
          id: descendant_channel_shops.select(:id)
        )
      end

      _shops
    }.call
  end
  alias :shops :self_and_descendant_shops

  def shop_ids
    @shop_ids ||= shops.pluck(:id)
  end

  def descendant_shops
    Shop.where(id: shop_ids.reject{|id| id == shop_id })
  end

  def descendant_shop_ids
    @descendant_shops_ids ||= shop_ids.reject{|id| id == shop_id }
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