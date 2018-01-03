class Api::OpenMobile::DashboardController < Api::OpenMobile::BaseController
  include ActionSearchable
  include Api::OpenMobile::ActionOwnable

  before_action :set_shops

  def index
    date = Date.today
    _raw_result = Rails.cache.fetch(get_cache_key(date), raw: true, expires_in: 30.minutes) {
      {
        date: Date.today,
        shop_count: @permit_shops.where(created_at: date.to_time.all_day).size,
        order_count: Order.sales_order.valided_order.where(
          shop_id: @permit_shops,
          created_at: date.to_time.all_day
        ).size,
        order_amount: Order.sales_order.valided_order.where(
          shop_id: @permit_shops,
          created_at: date.to_time.all_day
        ).sum(:total_price)
      }.to_yaml
    }

    @result = YAML.load(_raw_result)
  end

  def user_grade_stat
    date = Date.today
    _raw_result = Rails.cache.fetch(get_cache_key(date), raw: true, expires_in: 30.minutes) {
      _counts = Shopkeeper.where(
        shop_id: @permit_shops
      ).group(:user_grade).count

      Shopkeeper.user_grades_i18n.map{|k,v|
        {
          user_grade: k,
          user_grade_text: v,
          count: _counts[k]
        }
      }.to_yaml
    }

    @result = YAML.load(_raw_result)
  end

  def children_rank
    _limit = (params[:limit].presence || 10).to_i
    _time_range = params[:time_range].presence || "3_day_ago"
    dates = distance_of_time_range(
      str: _time_range,
      from_time: Time.now.end_of_day
    )

    _raw_result = Rails.cache.fetch(get_cache_key(_time_range, _limit), raw: true, expires_in: 30.minutes) {
      _counts = Shopkeeper.where(
        shop_id: @permit_shops,
        created_at: dates
      ).group(:invite_user_id).order(
        "count(`invite_user_id`) desc"
        ).limit(_limit).pluck_s(
          "`invite_user_id` as user_id",
          "count(`invite_user_id`) as count"
        )
      _shopkeepers = Shopkeeper.preload(:shop).where(user_id: _counts.pluck(:user_id))

      _counts.map.with_index(1).each {|item, index|
        _shopkeeper = _shopkeepers.find{|record|
          record.user_id == item.user_id
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

  def order_amount_rank
    _limit = (params[:limit].presence || 10).to_i
    _time_range = params[:time_range].presence || "3_day_ago"
    dates = distance_of_time_range(
      str: _time_range,
      from_time: Time.now.end_of_day
    )

    _raw_result = Rails.cache.fetch(get_cache_key(_time_range, _limit), raw: true, expires_in: 30.minutes) {
      _counts = ReportShopActivity.where(
        shop_id: @permit_shops,
        report_date: dates
      ).group(:shop_id).order(
        "sum(`order_amount`) desc"
        ).limit(_limit).pluck_s(
          "`shop_id` as shop_id",
          "sum(`order_amount`) as amount"
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
          amount: item.amount
        }
      }.to_yaml
    }

    @result = YAML.load(_raw_result)
  end

  def city_rank
    _limit = (params[:limit].presence || 10).to_i
    _time_range = params[:time_range].presence || "3_day_ago"
    dates = distance_of_time_range(
      str: _time_range,
      from_time: Time.now.end_of_day
    )

    _raw_result = Rails.cache.fetch(get_cache_key(_time_range, _limit), raw: true, expires_in: 30.minutes) {
      _counts = Shopkeeper.where(
          shop_id: @permit_shops,
          created_at: dates
        ).where.not(city: "").
        group(:city).order("count(city) desc").
        limit(_limit).pluck_s(
          "`city` as city",
          "count(`city`) as count"
        )

      _counts.map.with_index(1).each {|item, index|
        {
          index: index,
          city: item.city,
          count: item.count
        }
      }.to_yaml
    }

    @result = YAML.load(_raw_result)
  end

  private
  def get_cache_key(*key)
    key = [request.path] << Array.wrap(key)
    key << @permit_shops if params[:shop_id].present?

    ActiveSupport::Cache.expand_cache_key(key)
  end
end