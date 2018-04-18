class Export::Dev::ProductSkuService
  include Export::BaseService

  def index_fields
    %w(
      product.no product
      product.category.parent product.category
      supplier brand
      shop_online_count
      sales_n sock_n
      created_at
    )
  end

  def index_head_names
    %w(
      产品编号 产品名称
      产品分类(一级) 产品分类(二级)
      供应商 品牌
      上架数
      已售数 库存
      创建时间
    )
  end

  def index_record_shop_online_count(record)
    record.product.product_shops.online.count
  end

  private
end