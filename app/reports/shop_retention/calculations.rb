module ShopRetention::Calculations

  def calculate(date: )
    _end_at = (date.beginning_of_month - 1).to_time.end_of_month
    _start_at = 3.months.ago(_end_at).beginning_of_month
    _shopkeepers = Shopkeeper.where(created_at: _start_at.._end_at)

    _result = {
      start_at: _start_at,
      end_at: _end_at,
      shopkeeper_count: Shopkeeper.where("created_at <= ?", _end_at).count,
      activation_shopkeeper_count: _shopkeepers.activation.count,
      retention_shopkeeper_count: _shopkeepers.where("order_number > ?", 1).count
    }
    if _result[:shopkeeper_count] > 0
      _result.merge!(
        activation_shopkeeper_rate: (_result[:activation_shopkeeper_count] / _result[:shopkeeper_count].to_f).round(3),
        retention_shopkeeper_rate: (_result[:retention_shopkeeper_count] / _result[:shopkeeper_count].to_f).round(3),
      )
    end

    _result
  end
end