class Export::Dev::CityShopActivityService
  include Export::BaseService

  def report_fields
    %w(
      id city
    ).concat(
      ReportCityShopActivity.stat_fields.reject{|field|
        field.start_with?("day_3_", "day_60_", "stage_")
      }
    )
  end

  def report_head_names
    %w(
      # 城市
    ).concat(
      ReportCityShopActivity.stat_fields.reject{|field|
        field.start_with?("day_3_", "day_60_", "stage_")
      }.map{|field|
        ReportCityShopActivity.human_attribute_name(field)
      }
    )
  end
end