class Api::OpenMobile::ShopsController < Api::OpenMobile::BaseController
  include ActionSearchable

  def summary
    @shop = Shop.find(params[:id])
  end

  def children_rank
    shop = Shop.find(params[:id])

    _limit = (params[:limit].presence || 10).to_i
    _time_range = params[:time_range].presence || "3_day_ago"
    dates = distance_of_time_range(
      str: _time_range,
      from_time: Time.now.end_of_day
    )

    _raw_result = Rails.cache.fetch("open_mobile:shops/#{shop.id}/:children_stat:#{_time_range}:limit:#{_limit}", raw: true, expires_in: 30.minutes) {
      _counts = shop.shopkeeper.descendant_entities.where(
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
          order_amount: _shopkeeper.order_amount.to_f.to_s,
          commission_income_amount: _shopkeeper.commission_income_amount.to_f.to_s,
          city: _shopkeeper.city,
          count: item.count
        }
      }.to_yaml
    }

    @result = YAML.load(_raw_result)
  end
end