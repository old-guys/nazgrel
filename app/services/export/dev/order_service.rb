class Export::Dev::OrderService
  include Export::BaseService

  def index_fields
    %w(
      order_no shop_name shop_username shopkeeper.user_grade_i18n recv_user_name
      recv_phone_no order_details_context total_price created_at
      province city full_address
    )
  end

  def index_head_names
    %w(
      订单编号 店铺名称 订单类型 店主姓名 店铺等级 收件人姓名 收件人手机号
      商品信息 订单金额 时间 省份 城市 收货地址
    )
  end

  def sales_fields
    %w(
      order_no shop_name order_type_i18n shop_username shopkeeper_user_grade_i18n shop_phone
      shared_count view_count
      product.no product_name supplier
      category product_num product_market_price
      product_sale_price pay_price created_at
      province city
    )
  end

  def sales_head_names
    %w(
      # 店铺名称 店主姓名 店主手机号 店铺等级
      分享数 浏览量 商品编号 商品名称
      商品分类 品牌 商品数量(件) 市场价格(元) 商品单价(元)
      支付金额 下单时间 省份 城市
    )
  end

  def sales_records_convert
    report_shop_activities ||= ReportShopActivity.where(
      shop_id: records.map(&:shop_id),
      report_date: records.map{|o| o.created_at.to_date }.uniq
    )

    records.map{|order|
      report = report_shop_activities.find {|report|
        report.shop_id == order.shop_id
      }

      order.order_subs.map {|order_sub|
        _supplier = order_sub.try(:supplier)
        order_sub.order_details.map {|order_detail|
          _product = order_detail.try(:product)

          OpenStruct.new(
            order_no: order.order_no,
            shop_name: order.shop_name,
            shop_username: order.shop_username,
            shopkeeper_user_grade_i18n: order.shopkeeper.try(:user_grade_i18n),
            shop_phone: order.shop_phone,
            shared_count: report.try(:shared_count),
            view_count: report.try(:view_count),
            product_no: _product.no,
            product_name: order_detail.product_name,
            supplier: _supplier.to_s,
            category: order_detail.category,
            product_num: order_detail.product_num,
            product_market_price: order_detail.product_market_price,
            product_sale_price: order_detail.product_sale_price,
            pay_price: order.pay_price,
            created_at: order.created_at,
            province: order.province,
            city: order.city
          )
        }
      }
    }.flatten
  end

  private
  def index_record_full_address(record)
    [record.province, record.city, record.detail_address].join(" ")
  end

  def index_record_order_details_context(record)
    record.order_details.map do |order_detail|
      "#{order_detail.product_name} * #{order_detail.product_sale_price} * #{order_detail.product_num}"
    end.join("\n")
  end
end