class Api::OpenMobile::ShopActivitiesController < Api::OpenMobile::BaseController
  include ActionSearchable
  include ActionUtilable
  include Api::OpenMobile::ActionOwnable

  before_action :set_shops, only: [
    :view_count_rank, :shared_count_rank,
    :viewer_count_rank
  ]

  def view_count_rank
    _limit = (params[:limit].presence || 10).to_i
    _time_range = params[:time_range].presence || "3_day_ago"
    dates = distance_of_time_range(
      str: _time_range,
      from_time: Time.now.end_of_day
    )

    _raw_result = Rails.cache.fetch(get_cache_key(_time_range, _limit), raw: true, expires_in: 30.minutes) {
      _counts = Shopkeeper.view_count_rank(
        records: Shopkeeper.where(shop_id: @permit_shops),
        dates: dates,
        limit: _limit
      )
      _shopkeepers = Shopkeeper.preload(:shop).where(shop_id: _counts.pluck(:shop_id))
      _counts.map.with_index(1).each {|item, index|
        _shopkeeper = _shopkeepers.find{|record|
          record.shop_id == item.shop_id
        }

        {
          index: index,
          shop_id: _shopkeeper.shop_id,
          shop_name: _shopkeeper.shop.to_s,
          Shopkeeper_name: _shopkeeper.to_s,
          city: _shopkeeper.city,
          count: item.count
        }
      }.to_yaml
    }

    @result = YAML.load(_raw_result)
  end

  def shared_count_rank
    _limit = (params[:limit].presence || 10).to_i
    _time_range = params[:time_range].presence || "3_day_ago"
    dates = distance_of_time_range(
      str: _time_range,
      from_time: Time.now.end_of_day
    )

    _raw_result = Rails.cache.fetch(get_cache_key(_time_range, _limit), raw: true, expires_in: 30.minutes) {
      _counts = Shopkeeper.share_count_rank(
        records: Shopkeeper.where(shop_id: @permit_shops),
        dates: dates,
        limit: _limit
      )
      _shopkeepers = Shopkeeper.preload(:shop).where(shop_id: _counts.pluck(:shop_id))
      _counts.map.with_index(1).each {|item, index|
        _shopkeeper = _shopkeepers.find{|record|
          record.shop_id == item.shop_id
        }

        {
          index: index,
          shop_id: _shopkeeper.shop_id,
          shop_name: _shopkeeper.shop.to_s,
          Shopkeeper_name: _shopkeeper.to_s,
          city: _shopkeeper.city,
          count: item.count
        }
      }.to_yaml
    }

    @result = YAML.load(_raw_result)
  end

  def viewer_count_rank
    _limit = (params[:limit].presence || 10).to_i
    _time_range = params[:time_range].presence || "3_day_ago"
    dates = distance_of_time_range(
      str: _time_range,
      from_time: Time.now.end_of_day
    )

    _raw_result = Rails.cache.fetch(get_cache_key(_time_range, _limit), raw: true, expires_in: 30.minutes) {
      _counts = Shopkeeper.viewer_count_rank(
        records: Shopkeeper.where(shop_id: @permit_shops),
        dates: dates,
        limit: _limit
      )
      _shopkeepers = Shopkeeper.preload(:shop).where(shop_id: _counts.pluck(:shop_id))
      _counts.map.with_index(1).each {|item, index|
        _shopkeeper = _shopkeepers.find{|record|
          record.shop_id == item.shop_id
        }

        {
          index: index,
          shop_id: _shopkeeper.shop_id,
          shop_name: _shopkeeper.shop.to_s,
          Shopkeeper_name: _shopkeeper.to_s,
          city: _shopkeeper.city,
          count: item.count
        }
      }.to_yaml
    }

    @result = YAML.load(_raw_result)
  end

  private
  def get_cache_key(*key)
    key = Array.wrap(key)
    key << @permit_shops if params[:shop_id].present?

    action_cache_key(key)
  end
end