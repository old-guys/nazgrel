class Export::Dev::ShopActivityService
  include Export::BaseService

  def report_fields
    %w(
      id shop.to_s shopkeeper.user_name shopkeeper.province shopkeeper.city
      shopkeeper.created_at shopkeeper.user_grade_i18n
    ).concat(
      ReportShopActivity.stat_fields
    )
  end

  def report_head_names
    %w(
      # 店铺名称 店主姓名 省份 城市
      创建时间 店铺等级
    ).concat(
      ReportShopActivity.stat_fields.map{|field|
        ReportShopActivity.human_attribute_name(field)
      }
    )
  end
end