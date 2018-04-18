class Export::Dev::OrderDetailService
  include Export::BaseService

  def sales_fields
    %w(
      product_category suppliers_context
      product.no product
      number amount
    )
  end

  def sales_head_names
    %w(
      分类 供应商
      产品编号 产品名称
      数量 销售额
    )
  end

  def sales_records_convert
    _order_details = records.pluck_s(
      :product_id,
      Arel.sql("max(`order_details`.`supplier_id`) AS supplier_id"),
      Arel.sql("max(`order_details`.`updated_at`) AS updated_at"),
      Arel.sql("sum(`order_details`.`product_num`) AS number"),
      Arel.sql("sum(`order_details`.`product_num` * `order_details`.`product_sale_price`) AS amount")
    )
    _suppliers = Supplier.where(id: _order_details.map(&:supplier_id))
    _products = Product.preload(:category).where(id: _order_details.map(&:product_id))

    _order_details.map{|record|
      _product = _products.find {|product| product.id == record.product_id }

      OpenStruct.new(
        product_category: _product.try(:category).to_s,
        product: _product.to_s,
        suppliers_context: _suppliers.find {|supplier| supplier.id == record.supplier_id }.to_s,
        number: record.number,
        amount: record.amount,
      )
    }
  end

  private
end