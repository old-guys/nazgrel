module DailyOperational::Calculations

  def calculate(date: )
    _datetimes = date.all_day

    _total_shopkeeper_count = Shopkeeper.where("created_at <= ?", date.end_of_day).count
    _shopkeeper_count = Shopkeeper.where(created_at: _datetimes).count
    _orders = Order.where(created_at: _datetimes)

    _activation_shopkeeper_count = _orders.count("distinct(shop_id)")
    _view_count = ViewJournal.where(created_at: _datetimes).count

    _order_total_price = _orders.sum(:total_price)
    _order_count = _orders.size

    {
      total_shopkeeper_count: Shopkeeper.where("created_at <= ?", date.end_of_day).count,
      shopkeeper_count: _shopkeeper_count,
      activation_shopkeeper_count: _activation_shopkeeper_count,
      activation_shopkeeper_rate:
        _total_shopkeeper_count > 0 ? (_activation_shopkeeper_count / _total_shopkeeper_count.to_f) : nil,
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
      activity_ticket_amount: ActUserTicket.where(
        id: _orders.where.not(user_ticket_id: nil).select(:user_ticket_id)
      ).sum("`act_user_tickets`.`amount`"),
      product_cost: OrderDetail.joins(
        :order, :product_sku
      ).merge(_orders).sum(
        "`order_details`.`product_num`*`product_skus`.`cost_price`"
      )
    }
  end

  private
end