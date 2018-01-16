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

  def summary
    @shop = Shop.find(params[:id])

    _limit = (params[:limit].presence || 10).to_i
    _time_range = params[:time_range].presence || "3_day_ago"
    dates = distance_of_time_range(
      str: _time_range,
      from_time: Time.now.end_of_day
    )

    _raw_result = Rails.cache.fetch(get_cache_key(_time_range, _limit), raw: true, expires_in: 30.minutes) {
      _view_type_counts = Shopkeeper.shop_view_type_count(
        shop_id: @shop.id,
        dates: dates,
        limit: _limit
      )
      _shared_type_counts = Shopkeeper.shop_shared_type_count(
        shop_id: @shop.id,
        dates: dates,
        limit: _limit
      )

      ViewJournal.types_i18n.map{|k,v|
        {
          type: k,
          type_text: v,
          view_count: _view_type_counts[k] || 0,
          shared_count: _shared_type_counts[k] || 0
        }
      }.to_yaml
    }

    @result = YAML.load(_raw_result)
  end

  def show
    _time_range = params[:time_range].presence || "3_day_ago"
    @date_range = distance_of_date_range(
      str: _time_range,
      from_time: Time.now.end_of_day
    )

    @report_shop_activities = ReportShopActivity.where(
      shop_id: params[:id],
      report_date: @date_range
    )
  end

  private
  def get_cache_key(*key)
    key = Array.wrap(key)
    key << @permit_shops if params[:shop_id].present?

    action_cache_key(key)
  end
end