class Api::OpenMobile::DashboardController < Api::OpenMobile::BaseController
  include ActionSearchable

  def index
    date = Date.today
    _raw_result = Rails.cache.fetch("open_mobile:dashboard:#{date.to_s}:index", raw: true, expires_in: 5.minutes) {
      {
        date: Date.today,
        shop_count: Shop.where(created_at: date.to_time.all_day).size,
        order_count: Order.sales_order.valided_order.where(
          created_at: date.to_time.all_day
        ).size,
        order_amount: Order.sales_order.valided_order.where(
          created_at: date.to_time.all_day
        ).sum(:total_price)
      }.to_yaml
    }

    @result = YAML.load(_raw_result)
  end

  def user_grade_stat
    date = Date.today
    _raw_result = Rails.cache.fetch("open_mobile:dashboard:#{date.to_s}:index", raw: true, expires_in: 5.minutes) {
      _counts = Shopkeeper.group(:user_grade).count

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

    _raw_result = Rails.cache.fetch("open_mobile:dashboard:children_rank:#{_time_range}:limit:#{_limit}", raw: true, expires_in: 15.minutes) {
      _counts = Shopkeeper.where(
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
end