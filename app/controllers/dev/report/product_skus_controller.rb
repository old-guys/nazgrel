class Dev::Report::ProductSkusController < Dev::Report::BaseController
  include ActionSearchable
  include ActionExportable

  def index
    @product_skus = ProductSku.joins(:product).preload(product: {
        category: :parent,
        product_brand_supplier: [:brand, :supplier]
      }).
      merge(
        Product.online
      ).higher_stock_sales_rate(rate: 0.9)

    @product_skus = @product_skus.
      order(Arel.sql("`product_skus`.`sales_n` / `product_skus`.`sock_n` DESC"))

    preload_export(service: 'Dev::ProductSku', action: 'index', relation: @product_skus)

    @product_skus = filter_by_pagination(relation: @product_skus)
  end

  private
end