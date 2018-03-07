class Export::Dev::OrderDetailService
  include Export::BaseService

  def sales_fields
    %w(
      product_category product suppliers_context
      product_skus_context number amount
    )
  end

  def sales_head_names
    %w(
      分类 产品名称 供应商
      库存 数量 销售额
    )
  end

  def sales_records_convert
    _order_details = records.pluck_s(
      :product_id,
      "max(`order_details`.`supplier_id`) AS supplier_id",
      "max(`order_details`.`updated_at`) AS updated_at",
      "sum(`order_details`.`product_num`) AS number",
      "sum(`order_details`.`product_num` * `order_details`.`product_sale_price`) AS amount"
    )
    _suppliers = Supplier.where(id: _order_details.map(&:supplier_id))
    _products = Product.preload(:category).where(id: _order_details.map(&:product_id))

    _order_details.map{|record|
      _product = _products.find {|product| product.id == record.product_id }
      _product_skus = ProductSku.where(
        id: collection.unscope(:group, :order).where(product_id: record.product_id).select(:product_sku_id)
      )

      OpenStruct.new(
        product_category: _product.try(:category).to_s,
        product: _product.to_s,
        suppliers_context: _suppliers.find {|supplier| supplier.id == record.supplier_id }.to_s,
        product_skus_context: _product_skus.map{|product_sku|
          "SKU: #{product_sku.sku_n} 成本: #{product_sku.cost_price} 使用: #{product_sku.sales_n}/#{product_sku.sock_n}"
        }.join("\n"),
        number: record.number,
        amount: record.amount,
      )
    }
  end

  private
end