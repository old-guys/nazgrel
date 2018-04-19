class Export::Dev::CumulativeProductSalesActivityService
  include Export::BaseService

  def report_fields
    %w(
      product.created_at product.released_at
      product.supplier product.brand
      product.category.parent product.category
      product.no product.to_s
      day_7_sales_amount day_30_sales_amount
      day_60_sales_amount
      quarter_1_sales_amount quarter_2_sales_amount
      quarter_3_sales_amount quarter_4_sales_amount
      day_7_sales_count day_30_sales_count
      day_60_sales_count
      quarter_1_sales_count quarter_2_sales_count
      quarter_3_sales_count quarter_4_sales_count
    )
  end

  def report_head_names
    %w(
      创建时间 上架时间
      供应商 品牌
      商品分类(一级) 商品分类(二级)
      商品编码 商品名称
      7天销售额 30天销售额
      60天销售额
      第1季度销售额 第2季度销售额
      第3季度销售额 第4季度销售额
      7天销量 30天销量
      60天销量
      第1季度销量 第2季度销量
      第3季度销量 第4季度销量
    )
  end
end