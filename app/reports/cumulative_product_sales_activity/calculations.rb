module CumulativeProductSalesActivity::Calculations

  def calculate(date: , product: , only_due_quarter: true)
    _datetime = date.to_datetime.end_of_day
    _result = {}

    _stage_result = cal_product_sales(
      product: product,
      datetimes: 7.days.ago(_datetime).._datetime
    )
    _result.merge!(
      day_7_sales_count: _stage_result[:count],
      day_7_sales_amount: _stage_result[:amount],
    )

    _stage_result = cal_product_sales(
      product: product,
      datetimes: 30.days.ago(_datetime).._datetime
    )
    _result.merge!(
      day_30_sales_count: _stage_result[:count],
      day_30_sales_amount: _stage_result[:amount],
    )

    _stage_result = cal_product_sales(
      product: product,
      datetimes: 60.days.ago(_datetime).._datetime
    )
    _result.merge!(
      day_60_sales_count: _stage_result[:count],
      day_60_sales_amount: _stage_result[:amount],
    )

    datetimes =  _datetime.change(month: 1 * 3).all_quarter
    if ! only_due_quarter || _datetime.in?(datetimes)
      _stage_result = cal_product_sales(
        product: product,
        datetimes: datetimes
      )
      _result.merge!(
        quarter_1_sales_count: _stage_result[:count],
        quarter_1_sales_amount: _stage_result[:amount],
      )
    end

    datetimes =  _datetime.change(month: 2 * 3).all_quarter
    if ! only_due_quarter || _datetime.in?(datetimes)
      _stage_result = cal_product_sales(
        product: product,
        datetimes: datetimes
      )
      _result.merge!(
        quarter_2_sales_count: _stage_result[:count],
        quarter_2_sales_amount: _stage_result[:amount],
      )
    end

    datetimes =  _datetime.change(month: 3 * 3).all_quarter
    if ! only_due_quarter || _datetime.in?(datetimes)
      _stage_result = cal_product_sales(
        product: product,
        datetimes: datetimes
      )
      _result.merge!(
        quarter_3_sales_count: _stage_result[:count],
        quarter_3_sales_amount: _stage_result[:amount],
      )
    end

    datetimes =  _datetime.change(month: 4 * 3).all_quarter
    if ! only_due_quarter || _datetime.in?(datetimes)
      _stage_result = cal_product_sales(
        product: product,
        datetimes: datetimes
      )
      _result.merge!(
        quarter_4_sales_count: _stage_result[:count],
        quarter_4_sales_amount: _stage_result[:amount],
      )
    end

    _result
  end

  private
  def cal_product_sales(product: , datetimes: )
    _result = {
      count: 0,
      amount: 0
    }

    _result = {
      count: cal_product_sales_count(
        product: product, datetimes: datetimes
      ),
      amount: cal_product_sales_amount(
        product: product, datetimes: datetimes
      )
    } if OrderDetail.where(
        product_id: product.id, created_at: datetimes
      ).exists?

    _result
  end

  def cal_product_sales_count(product: , datetimes: )
    order_details_by_product(
      product: product,
      datetimes: datetimes
    ).sum(:product_num)
  end

  def cal_product_sales_amount(product: , datetimes: )
    order_details_by_product(
      product: product,
      datetimes: datetimes
    ).sum(
      Arel.sql("`order_details`.`product_num` * `order_details`.`product_sale_price`")
    )
  end

  def order_details_by_product(product: , datetimes: )
    _orders = Order.valided_order.
      where(created_at: datetimes)

    OrderDetail.joins(:order).merge(_orders).where(
      product_id: product.id
    )
  end
end