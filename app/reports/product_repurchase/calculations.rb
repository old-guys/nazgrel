module ProductRepurchase::Calculations

  def calculate(start_at: , end_at: , category: )
    _products = Product.online.where(category: category.self_and_descendant_entities)
    _product_skus = ProductSku.where(
      product: _products,
      created_at: start_at..end_at
    )
    _order_details = OrderDetail.joins(:order).merge(
      Order.valided_order.sales_order.where(
        created_at: start_at..end_at
      )
    ).where(
      product_sku_id: _product_skus.select(:id)
    )

    _result = {
      online_product_sku_count: _product_skus.count,
      purchase_product_sku_count: _order_details.count("distinct(product_sku_id)"),
      repurchase_product_sku_count: _order_details.group(
        "`orders`.`user_id`", "`order_details`.`product_sku_id`"
      ).having(
        "count(`orders`.`user_id`) > 1"
      ).pluck_s(
        Arel.sql("`order_details`.`product_sku_id` AS product_sku_id"),
        Arel.sql("`orders`.`user_id` AS user_id")
      ).map(&:product_sku_id).uniq.count
    }
    if _result[:online_product_sku_count] > 0
      _result.merge!(
        activation_product_rate: (_result[:purchase_product_sku_count] / _result[:online_product_sku_count].to_f).round(3),
        repurchase_product_rate: (_result[:repurchase_product_sku_count] / _result[:online_product_sku_count].to_f).round(3),
      )
    end

    _result
  end
end