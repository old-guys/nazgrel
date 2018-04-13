class Export::Dev::OperationalCumulativeShopActivityService
  include Export::BaseService

  def report_fields
    %w(
      shop_id shop.to_s
      shopkeeper.to_s shopkeeper.province
      shopkeeper.city shopkeeper.created_at
      shopkeeper.user_grade_i18n
    ).concat(
      stat_fields(stat_category: params[:stat_category])
    )
  end

  def report_head_names
    %w(
      # 店铺名称
      店主姓名 省份
      城市 开店时间
      店铺等级
    ).concat(stat_fields(stat_category: params[:stat_category]).map{|field|
      ReportCumulativeShopActivity.human_attribute_name(field)
    })
  end

  private
  def stat_fields(stat_category: )
    %w(day_0 day_3 day_7 day_30).map{|stage|
      "#{stage}_#{stat_category}"
    }
  end
end