module ShopActivity::Calculations
  def aggregation_by_day(shop:, date: , partial_update: false)
    _date = date.dup
    result = {}

    _records = SesameMall::Source::ViewJournal.where(shop_id: shop.id)
    result.merge!(aggregation_field_by_day(
      field: :view_count, date: date, records: _records,
      date_column: :DATE, force_utc: true,
      partial_update: partial_update
    ))

    _records = SesameMall::Source::ShareJournal.where(shop_id: shop.id)
    result.merge!(aggregation_field_by_day(
      field: :shared_count, date: date, records: _records,
      date_column: :DATE, force_utc: true,
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
    sum_block ||= proc {|sql|
      sql.size
    }
    _time = force_utc ? date.to_time.utc : date.to_time

    result = {
      "#{field}": sum_block.call(records.where(
        "#{date_column}": _time.all_day
      )),
      "stage_1_#{field}": sum_block.call(records.where(
        "#{date_column}": _time.change(hour: 0).._time.utc.change(hour: 8).end_of_hour
      )),
      "stage_2_#{field}": sum_block.call(records.where(
        "#{date_column}": _time.change(hour: 9).._time.change(hour: 17).end_of_hour
      )),
      "stage_3_#{field}": sum_block.call(records.where(
        "#{date_column}": _time.change(hour: 18).._time.change(hour: 23).end_of_hour
      ))
    }

    if not partial_update
      result.merge!({
        "month_#{field}": sum_block.call(records.where(
          "#{date_column}": _time.beginning_of_month.._time.end_of_day
        )),
        "year_#{field}": sum_block.call(records.where(
          "#{date_column}": _time.beginning_of_year.._time.end_of_day
        ))
      })
    end

    result
  end
end