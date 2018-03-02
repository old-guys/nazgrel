module DailyOperational::Calculations

  def calculate(date: )
    _datetimes = date.all_day

    _shopkeeper_count = Shopkeeper.where(created_at: _datetimes).count
    _activation_shopkeeper_count = Shopkeeper.where(created_at: _datetimes).where.not(order_number: nil).size
    _view_count = ViewJournal.where(created_at: _datetimes).count
    _orders = Order.where(created_at: _datetimes)
    _order_total_price = _orders.sum(:total_price)
    _order_count = _orders.size

    {
      total_shopkeeper_count: Shopkeeper.where("created_at <= ?", date.end_of_day).count,
      shopkeeper_count: _shopkeeper_count,
      activation_shopkeeper_count: _activation_shopkeeper_count,
      activation_shopkeeper_rate:
        _shopkeeper_count > 0 ? (_activation_shopkeeper_count / _shopkeeper_count.to_f) : nil,
      view_count: ViewJournal.where(created_at: _datetimes).count,
      viewer_count: ViewJournal.where(created_at: _datetimes).count("distinct(viewer_id)"),
      shared_count: ShareJournal.where(created_at: _datetimes).count,
      order_total_price: _order_total_price,
      order_count: _order_count,
      order_pay_price: _orders.sum(:pay_price),
      order_conversion_rate:
        _view_count > 0 ? (_order_count / _view_count.to_f) : nil,
      order_total_price_avg:
        _order_count > 0 ? (_order_total_price / _order_count.to_f) : nil,
      commission_income_amount: _orders.sum(:comm),
      # TODO Calculate 现金券金额
      activity_ticket_amount: nil,
      # TODO Calculate 成本
      product_cost: nil
    }
  end

  private
end