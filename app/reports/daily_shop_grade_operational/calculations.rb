module DailyShopGradeOperational::Calculations

  def calculate(date: )
    _datetimes = date.all_day
    _shopkeepers = Shopkeeper.where(created_at: _datetimes)

    {
      grade_trainee_count: _shopkeepers.org_grade_grade_trainee.count,
      activation_grade_trainee_count: cal_activation_grade_trainee_count(datetimes: _datetimes),
      trainee_upgrade_gold_count: Shopkeeper.org_grade_grade_trainee.
        where(upgrade_grade_gold_at: _datetimes).count,
      trainee_upgrade_platinum_count: Shopkeeper.org_grade_grade_trainee.
        where(upgrade_grade_platinum_at: _datetimes).count,
      gold_upgrade_platinum_count: Shopkeeper.org_grade_grade_gold.
        where(upgrade_grade_platinum_at: _datetimes).count,

      grade_gold_count: _shopkeepers.org_grade_grade_gold.count,
      grade_platinum_count: _shopkeepers.org_grade_grade_platinum.count,

      shopkeeper_count: _shopkeepers.count
    }
  end

  private
  def cal_activation_grade_trainee_count(datetimes: )
    _shopkeepers = Shopkeeper.org_grade_grade_trainee.where(
      user_id: Order.valided_order.where(
        created_at: datetimes,
        order_type: Order.order_types.slice(:shopkeeper_order, :third_order).values
      ).select(:user_id)
    )
    _exclude_shopkeepers = Shopkeeper.joins(:orders).where(
      id: _shopkeepers.select(:id),
      orders: {
        order_type: Order.order_types.slice(:shopkeeper_order, :third_order).values,
      }
    ).merge(Order.where("orders.created_at < ?", datetimes.first));

    _shopkeepers.where.not(
      id: _exclude_shopkeepers.select(:id)
    ).count
  end
end