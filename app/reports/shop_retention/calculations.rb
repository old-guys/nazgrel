module ShopRetention::Calculations

  def calculate(date: )
    if date.day == 1
      _end_at = (date.beginning_of_month - 1).to_time.end_of_month
      _start_at = 2.months.ago(_end_at).beginning_of_month
    end
    if date.day == 16
      _end_at = date.change(day: 15)
      _start_at = 3.months.ago(_end_at).change(day: 16)
    end

    _shopkeepers = Shopkeeper.where("shopkeepers.created_at <= ?", _end_at)
    _orders = Order.joins(:shopkeeper).where(
      order_status: Order.order_statuses.slice(:awaiting_delivery, :deliveried, :finished).values
    ).sales_order.where(
      created_at: _start_at.._end_at
    ).merge(_shopkeepers)

    _result = {
      start_at: _start_at,
      end_at: _end_at,
      shopkeeper_count: _shopkeepers.count,
      activation_shopkeeper_count: _orders.count("distinct(`orders`.`shop_id`)"),
      retention_shopkeeper_count: _orders.group(:shop_id).having("count(`orders`.`shop_id`) > 1").pluck_s(
        Arel.sql("distinct(`orders`.`shop_id`) AS shop_id")
      ).count
    }
    if _result[:shopkeeper_count] > 0
      _result.merge!(
        activation_shopkeeper_rate: (_result[:activation_shopkeeper_count] / _result[:shopkeeper_count].to_f).round(3)
      )
    end
    if _result[:activation_shopkeeper_count] > 0
      _result.merge!(
        retention_shopkeeper_rate: (_result[:retention_shopkeeper_count] / _result[:activation_shopkeeper_count].to_f).round(3),
      )
    end

    _result
  end
end