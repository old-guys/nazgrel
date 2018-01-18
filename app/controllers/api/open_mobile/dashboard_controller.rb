class Api::OpenMobile::DashboardController < Api::OpenMobile::BaseController
  include ActionSearchable
  include ActionUtilable
  include Api::OpenMobile::ActionOwnable


  before_action :set_shopkeepers

  def index
    date = Date.today
    _raw_result = Rails.cache.fetch(get_cache_key(date), raw: true, expires_in: 30.minutes) {
      {
        shop_count: @permit_shopkeepers.where(created_at: date.to_time.all_day).size,
        order_count: Order.sales_order.valided_order.where(
          shop_id: @permit_shopkeepers.select(:shop_id),
          created_at: date.to_time.all_day
        ).size,
        commission_income_amount: Order.sales_order.valided_order.where(
          shop_id: @permit_shopkeepers.select(:shop_id),
          created_at: date.to_time.all_day
        ).sum(:comm),
        order_amount: Order.sales_order.valided_order.where(
          shop_id: @permit_shopkeepers.select(:shop_id),
          created_at: date.to_time.all_day
        ).sum(:total_price)
      }.to_yaml
    }

    @result = YAML.load(_raw_result)
    @result.merge!(
      datetime: Time.now.to_s(:db)
    )
  end

  def user_grade_stat
    date = Date.today
    _raw_result = Rails.cache.fetch(get_cache_key(date), raw: true, expires_in: 30.minutes) {
      _counts = @permit_shopkeepers.group(:user_grade).count

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
      _counts = Shopkeeper.children_rank(
        records: @permit_shopkeepers,
        dates: dates,
        limit: _limit
      )
      _shopkeepers = Shopkeeper.preload(:shop).where(user_id: _counts.pluck(:user_id))

      _counts.map.with_index(1).each {|item, index|
        _shopkeeper = _shopkeepers.find{|record|
          record.user_id == item.user_id
        }

        {
          index: index,
          shop_id: _shopkeeper.shop_id,
          shop_img_url: _shopkeeper.shop_img_url,
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
      _counts = Shopkeeper.order_amount_rank(
        records: @permit_shopkeepers,
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
          shop_img_url: _shopkeeper.shop_img_url,
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
      _counts = Shopkeeper.city_rank(
        records: @permit_shopkeepers,
        dates: dates,
        limit: _limit
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
    key = Array.wrap(key)
    key << @permit_shopkeepers if params[:shop_id].present?

    action_cache_key(key)
  end
end