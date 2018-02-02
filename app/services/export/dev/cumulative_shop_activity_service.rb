class Export::Dev::CumulativeShopActivityService
  include Export::BaseService

  def report_fields
    %w(
      id shop.to_s shopkeeper.user_name shopkeeper.province shopkeeper.city
      shopkeeper.created_at shopkeeper.user_grade_i18n
    ).concat(
      ReportCumulativeShopActivity.stat_fields.reject{|field|
       field.start_with?("day_3_", "day_60_")
     }
    )
  end

  def report_head_names
    %w(
      # 店铺名称 店主姓名 省份 城市
      创建时间 店铺等级
    ).concat(
      ReportCumulativeShopActivity.stat_fields.reject{|field|
        field.start_with?("day_3_", "day_60_")
      }.map{|field|
        ReportCumulativeShopActivity.human_attribute_name(field)
      }
    )
  end
end