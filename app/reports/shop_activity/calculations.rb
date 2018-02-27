module ShopActivity::Calculations
  def aggregation_by_day(shop:, date: , partial_update: false)
    _date = date.dup
    result = {}

    _records = ViewJournal.where(shop_id: shop.id)
    result.merge!(aggregation_field_by_day(
      field: :view_count, date: date, records: _records,
      date_column: :created_at,
      partial_update: partial_update
    ))

    _records = ViewJournal.where(shop_id: shop.id)
    result.merge!(aggregation_field_by_day(
      field: :viewer_count, date: date, records: _records,
      date_column: :created_at,
      partial_update: partial_update,
      sum_block: proc{|sql| sql.count("distinct(viewer_id)") }
    ))

    _records = ::ShareJournal.where(shop_id: shop.id)
    result.merge!(aggregation_field_by_day(
      field: :shared_count, date: date, records: _records,
      date_column: :created_at,
      partial_update: partial_update
    ))

    _records = shop.orders.valided_order.sales_order
    result.merge!(aggregation_field_by_day(
      field: :order_number, date: date, records: _records,
      partial_update: partial_update
    ))

    _records = shop.orders.valided_order.sales_order.where(
      user_id: shop.shopkeeper.user_id
    )
    result.merge!(aggregation_field_by_day(
      field: :shopkeeper_order_number, date: date, records: _records,
      partial_update: partial_update
    ))

    _records = shop.orders.valided_order.sales_order.where.not(
      user_id: shop.shopkeeper.user_id
    )
    result.merge!(aggregation_field_by_day(
      field: :sale_order_number, date: date, records: _records,
      partial_update: partial_update
    ))

    _records = shop.orders.valided_order.sales_order
    result.merge!(aggregation_field_by_day(
      field: :commission_income_amount, date: date, records: _records,
      partial_update: partial_update,
      sum_block: proc{|sql| sql.sum(:comm) }
    ))

    _records = shop.orders.valided_order.sales_order
    result.merge!(aggregation_field_by_day(
      field: :order_amount, date: date, records: _records,
      partial_update: partial_update,
      sum_block: proc{|sql| sql.sum(:total_price) }
    ))

    _records = shop.orders.valided_order.sales_order.where(
      user_id: shop.shopkeeper.user_id
    )
    result.merge!(aggregation_field_by_day(
      field: :shopkeeper_order_amount, date: date, records: _records,
      partial_update: partial_update,
      sum_block: proc{|sql| sql.sum(:total_price) }
    ))

    _records = shop.orders.valided_order.sales_order.where.not(
      user_id: shop.shopkeeper.user_id
    )
    result.merge!(aggregation_field_by_day(
      field: :sale_order_amount, date: date, records: _records,
      partial_update: partial_update,
      sum_block: proc{|sql| sql.sum(:total_price) }
    ))

    _records = shop.shopkeeper.children.grade_platinum
    result.merge!(aggregation_field_by_day(
      field: :children_grade_platinum_count, date: date, records: _records,
      partial_update: partial_update
    ))

    _records = shop.shopkeeper.children.grade_gold
    result.merge!(aggregation_field_by_day(
      field: :children_grade_gold_count, date: date, records: _records,
      partial_update: partial_update
    ))

    _records = shop.shopkeeper.children
    result.merge!(aggregation_field_by_day(
      field: :children_count, date: date, records: _records,
      partial_update: partial_update
    ))

    _records = shop.shopkeeper.children
    result.merge!(aggregation_field_by_day(
      field: :children_commission_income_amount, date: date, records: _records,
      partial_update: partial_update,
      sum_block: proc{|sql| sql.sum(:commission_income_amount) }
    ))

    _records = shop.shopkeeper.descendant_entities
    result.merge!(aggregation_field_by_day(
      field: :descendant_count, date: date, records: _records,
      partial_update: partial_update
    ))

    _records = shop.shopkeeper.descendant_entities
    result.merge!(aggregation_field_by_day(
      field: :descendant_order_number, date: date, records: _records,
      partial_update: partial_update,
      sum_block: proc{|sql| sql.sum(:order_number) }
    ))

    _records = shop.shopkeeper.descendant_entities
    result.merge!(aggregation_field_by_day(
      field: :descendant_order_amount, date: date, records: _records,
      partial_update: partial_update,
      sum_block: proc{|sql| sql.sum(:order_amount) }
    ))

    _records = shop.shopkeeper.descendant_entities
    result.merge!(aggregation_field_by_day(
      field: :descendant_commission_income_amount, date: date, records: _records,
      partial_update: partial_update,
      sum_block: proc{|sql| sql.sum(:commission_income_amount) }
    ))

    _records = shop.shopkeeper.descendant_entities.grade_platinum
    result.merge!(aggregation_field_by_day(
      field: :ecn_grade_platinum_count, date: date, records: _records,
      partial_update: partial_update
    ))

    _records = shop.shopkeeper.descendant_entities.grade_gold
    result.merge!(aggregation_field_by_day(
      field: :ecn_grade_gold_count, date: date, records: _records,
      partial_update: partial_update
    ))
  end

  def calculate(shop: , date: ,partial_update: )
    aggregation_by_day(
      shop: shop, date: date, partial_update: partial_update
    )
  end

  private
  def aggregation_field_by_day(field: , date: , records: , date_column: :created_at, force_utc: false, partial_update: true, sum_block: nil)
    sum_block ||= proc {|relation|
      relation.size
    }
    _time = force_utc ? date.to_time.utc : date.to_time

    result = {
      "stage_1_#{field}": cached_daily_result(
        field: field,
        datetimes: _time.change(hour: 0).._time.change(hour: 8).end_of_hour,
        relation: records.where(
          "#{date_column}": _time.change(hour: 0).._time.change(hour: 8).end_of_hour
        ),
        sum_block: sum_block
      ),
      "stage_2_#{field}": cached_daily_result(
        field: field,
        datetimes: _time.change(hour: 9).._time.change(hour: 17).end_of_hour,
        relation: records.where(
          "#{date_column}": _time.change(hour: 9).._time.change(hour: 17).end_of_hour
        ),
        sum_block: sum_block
      ),
      "stage_3_#{field}": cached_daily_result(
        field: field,
        datetimes: _time.change(hour: 18).._time.change(hour: 23).end_of_hour,
        relation: records.where(
          "#{date_column}": _time.change(hour: 18).._time.change(hour: 23).end_of_hour
        ),
        sum_block: sum_block
      )
    }

    result.merge!(
      "#{field}": result.values.compact.sum
    )

    if not partial_update
      result.merge!({
        "week_#{field}": sum_block.call(records.where(
          "#{date_column}": _time.beginning_of_week.._time.end_of_day
        )),
        "month_#{field}": sum_block.call(records.where(
          "#{date_column}": _time.beginning_of_month.._time.end_of_day
        )),
        "year_#{field}": sum_block.call(records.where(
          "#{date_column}": _time.beginning_of_year.._time.end_of_day
        )),
        "total_#{field}": sum_block.call(records)
      })
    end

    result
  end

  def cached_daily_result(field: , datetimes: , relation: , sum_block: )
    return sum_block.call(relation) if not datetimes.first.to_date == Date.today
    _time = Time.now
    _cache_key = "cached_daily_result:#{field}:" << Digest::SHA1.hexdigest(relation.to_sql)
    if _time < datetimes.first
      return 0
    end
    if _time.between?(datetimes.first, datetimes.last)
      _value = sum_block.call(relation)
      Rails.cache.write(_cache_key, _value)

      return _value
    end
    if _time > datetimes.last
      return Rails.cache.fetch(_cache_key) {
        sum_block.call(relation)
      }
    end
  end
end