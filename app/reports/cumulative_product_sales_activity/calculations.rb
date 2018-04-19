module CumulativeProductSalesActivity::Calculations

  def calculate(date: , product: )
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

    _stage_result = cal_product_sales(
      product: product,
      datetimes: _datetime.change(month: 1 * 3).all_quarter
    )
    _result.merge!(
      quarter_1_sales_count: _stage_result[:count],
      quarter_1_sales_amount: _stage_result[:amount],
    )

    _stage_result = cal_product_sales(
      product: product,
      datetimes: _datetime.change(month: 2 * 3).all_quarter
    )
    _result.merge!(
      quarter_2_sales_count: _stage_result[:count],
      quarter_2_sales_amount: _stage_result[:amount],
    )

    _stage_result = cal_product_sales(
      product: product,
      datetimes: _datetime.change(month: 3 * 3).all_quarter
    )
    _result.merge!(
      quarter_3_sales_count: _stage_result[:count],
      quarter_3_sales_amount: _stage_result[:amount],
    )

    _stage_result = cal_product_sales(
      product: product,
      datetimes: _datetime.change(month: 4 * 3).all_quarter
    )
    _result.merge!(
      quarter_4_sales_count: _stage_result[:count],
      quarter_4_sales_amount: _stage_result[:amount],
    )

    _result
  end

  private
  def cal_product_sales(product: , datetimes: )
    return {} if product.created_at > datetimes.last
    _result = {
      count: cal_product_sales_count(product: product, datetimes: datetimes),
      amount: 0
    }

    if _result[:count].to_i > 0
      _result[:amount] = cal_product_sales_amount(
        product: product, datetimes: datetimes
      )
    end

    _result
  end

  def cal_product_sales_count(product: , datetimes: )
    OrderDetail.where(
      product_id: product.id,
      created_at: datetimes
    ).sum(:product_num)
  end

  def cal_product_sales_amount(product: , datetimes: )
    OrderDetail.where(
      product_id: product.id,
      created_at: datetimes
    ).sum(Arel.sql("`order_details`.`product_num` * `order_details`.`product_sale_price`"))
  end
end