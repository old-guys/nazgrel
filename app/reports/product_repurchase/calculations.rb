module ProductRepurchase::Calculations

  def calculate(start_at: , end_at: , category: )
    _products = Product.where(
      category: category.self_and_descendant_entities
    ).where("`products`.`created_at` <= ?", end_at)
    # FIXME zmall product_sku missing `created_at`, use `product#created_at` instead
    _product_skus = ProductSku.where(
      product: _products
    )
    _order_details = OrderDetail.joins(:order).merge(
      Order.where(
        order_status: Order.order_statuses.slice(:awaiting_delivery, :deliveried, :finished).values
      ).sales_order.where("`orders`.`created_at` <= ?", end_at)
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
        activation_product_rate: (_result[:purchase_product_sku_count] / _result[:online_product_sku_count].to_f).round(3)
      )
    end
    if _result[:purchase_product_sku_count] > 0
      _result.merge!(
        repurchase_product_rate: (_result[:repurchase_product_sku_count] / _result[:purchase_product_sku_count].to_f).round(3),
      )
    end

    _result
  end
end