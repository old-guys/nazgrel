class Api::OpenMobile::ShopsController < Api::OpenMobile::BaseController
  include ActionSearchable
  include ActionUtilable

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

    _raw_result = Rails.cache.fetch(action_cache_key(_time_range, _limit), raw: true, expires_in: 30.minutes) {
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

  def city_rank
    shop = Shop.find(params[:id])
    _limit = (params[:limit].presence || 10).to_i

    _rank_proc = proc {|date, limit|
      _expires_in = (date <= Date.today) ? 1.months : 30.minutes
      _raw_result = Rails.cache.fetch(action_cache_key(date, limit), raw: true, expires_in: _expires_in) {
        _counts = shop.shopkeeper.descendant_entities.where(
            created_at: date.to_time.beginning_of_month..date.to_time.end_of_day
          ).where.not(city: "").
          group(:city).order("count(city) desc").
          limit(limit).pluck_s(
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

      YAML.load(_raw_result)
    }
    date = Date.today
    _this_month_result = _rank_proc.call(date, _limit)
    _recent_month_result = _rank_proc.call(1.months.ago(date), _limit * 5)
    _state_hash = {
      up: 1,
      eq: 0,
      down: -1
    }

    @result = _this_month_result.map {|item|
      _recent_item = _recent_month_result.find{|recent_item|
        item[:city] == recent_item[:city]
      }
      _state = _recent_item ? _recent_item.index <=> item.index : 1

      item.merge(
        state: _state_hash.invert[_state]
      )
    }
  end
end