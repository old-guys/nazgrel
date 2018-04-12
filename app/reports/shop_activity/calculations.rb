module ShopActivity::Calculations
  def aggregation_by_day(shop: , date: , partial_update: false, updated_at: Time.now)
    _date = date.dup
    _updated_at = updated_at || Time.now
    result = {}

    if should_aggregation?(shop: shop, klass: ViewJournal, updated_at: _updated_at)
      _records = ViewJournal.where(shop_id: shop.id)
      result.merge!(aggregation_field_by_day(
        field: :view_count, date: date, records: _records,
        date_column: :created_at,
        partial_update: partial_update
      ))
    end

    if should_aggregation?(shop: shop, klass: ViewJournal, updated_at: _updated_at)
      _records = ViewJournal.where(shop_id: shop.id)
      result.merge!(aggregation_field_by_day(
        field: :viewer_count, date: date, records: _records,
        date_column: :created_at,
        partial_update: partial_update,
        sum_block: proc{|sql| sql.count("distinct(viewer_id)") }
      ))
    end

    if should_aggregation?(shop: shop, klass: ShareJournal, updated_at: _updated_at)
      _records = ::ShareJournal.where(shop_id: shop.id)
      result.merge!(aggregation_field_by_day(
        field: :shared_count, date: date, records: _records,
        date_column: :created_at,
        partial_update: partial_update
      ))
    end

    if should_aggregation?(shop: shop, klass: Order, updated_at: _updated_at)
      _records = shop.orders.valided_order.sales_order
      result.merge!(aggregation_field_by_day(
        field: :order_number, date: date, records: _records,
        partial_update: partial_update
      ))
    end

    if should_aggregation?(shop: shop, klass: Order, updated_at: _updated_at)
      _records = shop.orders.valided_order.sales_order.where(
        user_id: shop.shopkeeper.user_id
      )
      result.merge!(aggregation_field_by_day(
        field: :shopkeeper_order_number, date: date, records: _records,
        partial_update: partial_update
      ))
    end

    if should_aggregation?(shop: shop, klass: Order, updated_at: _updated_at)
      _records = shop.orders.valided_order.sales_order.where.not(
        user_id: shop.shopkeeper.user_id
      )
      result.merge!(aggregation_field_by_day(
        field: :sale_order_number, date: date, records: _records,
        partial_update: partial_update
      ))
    end

    if should_aggregation?(shop: shop, klass: Order, updated_at: _updated_at)
      _records = shop.orders.valided_order.sales_order
      result.merge!(aggregation_field_by_day(
        field: :commission_income_amount, date: date, records: _records,
        partial_update: partial_update,
        sum_block: proc{|sql| sql.sum(:comm) }
      ))
    end

    if should_aggregation?(shop: shop, klass: IncomeRecord, updated_at: _updated_at)
      _records = shop.income_records.withdraw_income.confirmed
      result.merge!(aggregation_field_by_day(
        field: :withdraw_amount, date: date, records: _records,
        partial_update: partial_update,
        sum_block: proc{|sql| sql.sum(:income_amount) }
      ))
    end

    if should_aggregation?(shop: shop, klass: IncomeRecord, updated_at: _updated_at)
      _records = shop.income_records.confirmed.invite_income.income.sesame_coin
      result.merge!(aggregation_field_by_day(
        field: :income_coin, date: date, records: _records,
        partial_update: partial_update,
        sum_block: proc{|sql| sql.sum(:income_amount) }
      ))
    end

    result.merge!(
      aggregation_recording_field_by_day(
        field: :balance_coin, date: date, records: shop,
        sum_block: proc{|arg| arg.shopkeeper.try(:balance_coin) }
      )
    )
    result.merge!(
      aggregation_recording_field_by_day(
        field: :income_amount, date: date, records: shop,
        sum_block: proc{|arg| arg.shopkeeper.try(:total_income_amount) }
      )
    )
    result.merge!(
      aggregation_recording_field_by_day(
        field: :balance_amount, date: date, records: shop,
        sum_block: proc{|arg| arg.shopkeeper.try(:balance_amount) }
      )
    )

    if should_aggregation?(shop: shop, klass: Order, updated_at: _updated_at)
      _records = shop.orders.valided_order.sales_order
      result.merge!(aggregation_field_by_day(
        field: :use_coin, date: date, records: _records,
        partial_update: partial_update,
        sum_block: proc{|sql| sql.sum(:virt_coin_reduce_price) }
      ))
    end

    if should_aggregation?(shop: shop, klass: Order, updated_at: _updated_at)
      _records = shop.orders.valided_order.sales_order
      result.merge!(aggregation_field_by_day(
        field: :order_amount, date: date, records: _records,
        partial_update: partial_update,
        sum_block: proc{|sql| sql.sum(:total_price) }
      ))
    end

    if should_aggregation?(shop: shop, klass: Order, updated_at: _updated_at)
      _records = shop.orders.valided_order.sales_order.where(
        user_id: shop.shopkeeper.user_id
      )
      result.merge!(aggregation_field_by_day(
        field: :shopkeeper_order_amount, date: date, records: _records,
        partial_update: partial_update,
        sum_block: proc{|sql| sql.sum(:total_price) }
      ))
    end

    if should_aggregation?(shop: shop, klass: Order, updated_at: _updated_at)
      _records = shop.orders.valided_order.sales_order.where.not(
        user_id: shop.shopkeeper.user_id
      )
      result.merge!(aggregation_field_by_day(
        field: :sale_order_amount, date: date, records: _records,
        partial_update: partial_update,
        sum_block: proc{|sql| sql.sum(:total_price) }
      ))
    end

    if should_aggregation?(shop: shop, klass: Shopkeeper, updated_at: _updated_at)
      _records = shop.shopkeeper.children.grade_platinum
      result.merge!(aggregation_field_by_day(
        field: :children_grade_platinum_count, date: date, records: _records,
        partial_update: partial_update
      ))
    end

    if should_aggregation?(shop: shop, klass: Shopkeeper, updated_at: _updated_at)
      _records = shop.shopkeeper.children.grade_gold
      result.merge!(aggregation_field_by_day(
        field: :children_grade_gold_count, date: date, records: _records,
        partial_update: partial_update
      ))
    end

    if should_aggregation?(shop: shop, klass: Shopkeeper, updated_at: _updated_at)
      _records = shop.shopkeeper.children
      result.merge!(aggregation_field_by_day(
        field: :children_count, date: date, records: _records,
        partial_update: partial_update
      ))
    end

    if should_aggregation?(shop: shop, klass: Shopkeeper, updated_at: _updated_at)
      _records = shop.shopkeeper.children
      result.merge!(aggregation_field_by_day(
        field: :children_commission_income_amount, date: date, records: _records,
        partial_update: partial_update,
        sum_block: proc{|sql| sql.sum(:commission_income_amount) }
      ))
    end

    if should_aggregation?(shop: shop, klass: Shopkeeper, updated_at: _updated_at)
      _records = shop.shopkeeper.descendant_entities
      result.merge!(aggregation_field_by_day(
        field: :descendant_count, date: date, records: _records,
        partial_update: partial_update
      ))
    end

    if should_aggregation?(shop: shop, klass: Shopkeeper, updated_at: _updated_at)
      _records = shop.shopkeeper.descendant_entities.activation
      result.merge!(aggregation_field_by_day(
        field: :descendant_activation_count, date: date, records: _records,
        partial_update: partial_update
      ))
    end

    if should_aggregation?(shop: shop, klass: Shopkeeper, updated_at: _updated_at)
      _records = shop.shopkeeper.descendant_entities
      result.merge!(aggregation_field_by_day(
        field: :descendant_order_number, date: date, records: _records,
        partial_update: partial_update,
        sum_block: proc{|sql| sql.sum(:order_number) }
      ))
    end

    if should_aggregation?(shop: shop, klass: Shopkeeper, updated_at: _updated_at)
      _records = shop.shopkeeper.descendant_entities
      result.merge!(aggregation_field_by_day(
        field: :descendant_order_amount, date: date, records: _records,
        partial_update: partial_update,
        sum_block: proc{|sql| sql.sum(:order_amount) }
      ))
    end

    if should_aggregation?(shop: shop, klass: Shopkeeper, updated_at: _updated_at)
      _records = shop.shopkeeper.descendant_entities
      result.merge!(aggregation_field_by_day(
        field: :descendant_commission_income_amount, date: date, records: _records,
        partial_update: partial_update,
        sum_block: proc{|sql| sql.sum(:commission_income_amount) }
      ))
    end

    if should_aggregation?(shop: shop, klass: Shopkeeper, updated_at: _updated_at)
      _records = shop.shopkeeper.descendant_entities.grade_platinum
      result.merge!(aggregation_field_by_day(
        field: :ecn_grade_platinum_count, date: date, records: _records,
        partial_update: partial_update
      ))
    end

    if should_aggregation?(shop: shop, klass: Shopkeeper, updated_at: _updated_at)
      _records = shop.shopkeeper.descendant_entities.grade_gold
      result.merge!(aggregation_field_by_day(
        field: :ecn_grade_gold_count, date: date, records: _records,
        partial_update: partial_update
      ))
    end

    result
  end

  def calculate(shop: , date: , partial_update: , updated_at: )
    aggregation_by_day(
      shop: shop, date: date, partial_update: partial_update,
      updated_at: updated_at
    )
  end

  private
  def aggregation_field_by_day(field: , date: , records: , date_column: :created_at, force_utc: false, partial_update: true, sum_block: nil)
    sum_block ||= proc {|relation|
      relation.size
    }
    _time = force_utc ? date.to_time.utc : date.to_time

    _time_sql = "CONVERT_TZ(`#{records.table_name}`.`#{date_column}`,'#{records.default_timezone}','#{Time.zone.formatted_offset}')"
    _stage_sql = Arel.sql(%Q{
      CASE
        when hour(#{_time_sql}) BETWEEN 0 and 8 then "stage_1"
        when hour(#{_time_sql}) BETWEEN 9 and 17 then "stage_2"
        when hour(#{_time_sql}) BETWEEN 18 and 23 then "stage_3"
      end
    })
    _value = sum_block.call(
      records.where(created_at: _time.all_day).group(_stage_sql)
    )

    result = {
      "stage_1_#{field}": _value["stage_1"] || 0,
      "stage_2_#{field}": _value["stage_2"] || 0,
      "stage_3_#{field}": _value["stage_3"] || 0
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

  # whether shopkeeper seek timestmap present and newer than report#updated_at
  # while true should exec aggregation
  # NOTICE timestamp check should add interval_time
  def should_aggregation?(shop: , klass: , updated_at: )
    _shopkeeper = shop.shopkeeper
    _value = _shopkeeper.seek_timestmap_service.value(target: klass)
    _interval_time = 3.minutes

    _value.present? ? updated_at < (_value + _interval_time) : true
  end

  def aggregation_recording_field_by_day(field: , date: , records: , sum_block: nil)
    result = {}
    _time = Time.now
    _value = sum_block.call(records)

    result.merge!(
      "#{field}": _value
    )
    result.merge!(
      "stage_1_#{field}": _value
    ) if _time.hour.between?(0, 8)
    result.merge!(
      "stage_2_#{field}": _value
    ) if _time.hour.between?(9, 17)
    result.merge!(
      "stage_2_#{field}": _value
    ) if _time.hour.between?(18, 23)
    result.merge!(
      "week_#{field}": _value
    ) if date == _time.to_date
    result.merge!(
      "month_#{field}": _value
    ) if date == _time.to_date
    result.merge!(
      "year_#{field}": _value
    ) if date == _time.to_date
    result.merge!(
      "total_#{field}": _value
    ) if date == _time.to_date

    result
  end
end