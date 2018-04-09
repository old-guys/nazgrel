module DailyOperationalShopGradeSummary::Calculations

  def calculate(date: )
    result = {}

    result.merge!(
      calculate_by_user_grade(date: date, user_grade: :grade_platinum)
    )
    result.merge!(
      calculate_by_user_grade(date: date, user_grade: :grade_gold)
    )
    result.merge!(
      calculate_by_user_grade(date: date, user_grade: :grade_trainee)
    )

    result
  end

  private
  def calculate_by_user_grade(date: , user_grade: )
    _shopkeepers = Shopkeeper.send(user_grade)
    _orders = Order.valided_order.where(
      created_at: date.all_day,
      order_type: Order.order_types.slice(:shopkeeper_order, :third_order).values
    )

    result = {
      "total_#{user_grade}_count": _shopkeepers.where("created_at <= ?", date.end_of_day).count,
      "#{user_grade}_count": _shopkeepers.where(created_at: date.all_day).count,
      "activation_#{user_grade}_count": _shopkeepers.where(
        user_id: _orders.select(:user_id)
      ).count,
      "#{user_grade}_order_number": _orders.joins(:shopkeeper).merge(_shopkeepers).count,
      "#{user_grade}_order_amount": _orders.joins(:shopkeeper).merge(_shopkeepers).sum(:pay_price),
      "#{user_grade}_sale_order_amount": _orders.joins(:shopkeeper).third_order.merge(_shopkeepers).sum(:pay_price),
      "#{user_grade}_shopkeeper_order_amount": _orders.joins(:shopkeeper).shopkeeper_order.merge(_shopkeepers).sum(:pay_price)
    }

    if result[:"#{user_grade}_order_amount"].to_f > 0
      result.merge!(
        "#{user_grade}_sale_order_amount_rate": (
          result[:"#{user_grade}_sale_order_amount"].to_f / result[:"#{user_grade}_order_amount"].to_f
        ).round(3),
        "#{user_grade}_shopkeeper_order_amount_rate": (
          result[:"#{user_grade}_shopkeeper_order_amount"].to_f / result[:"#{user_grade}_order_amount"].to_f
        ).round(3)
      )
    end

    result
  end
end