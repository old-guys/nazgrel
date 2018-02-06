module CumulativeShopActivity::Calculations

  def calculate(shop_id: , date: )
    result = ReportCumulativeShopActivity.stat_cumulative_stages.each_with_object({}) {|stage, hash|
      _result = calculate_by_stage(stage: stage, shop_id: shop_id, date: date) || {}
      hash.merge!(_result)
    }

    _result = calculate_by_total(shop_id: shop_id, date: date) || {}
    result.merge!(
      _result
    )
  end

  private
  def calculate_by_stage(stage: , shop_id: , date:)
    _sum_fields = ReportCumulativeShopActivity.stat_categories.map {|field|
      "sum(`report_shop_activities`.`#{field}`) as #{stage}_#{field}"
    }
    dates = (stage.split("_").last.to_i).days.ago(date)..date

    ReportShopActivity.where(
      report_date: dates,
      shop_id: shop_id
    ).pluck_h(*_sum_fields).pop.try(:reject){|_,v|
      v.blank?
    }
  end

  def calculate_by_total(shop_id: , date:)
    _sum_fields = ReportCumulativeShopActivity.stat_categories.map {|field|
      "(`report_shop_activities`.`total_#{field}`) as total_#{field}"
    }

    ReportShopActivity.where(
      report_date: date,
      shop_id: shop_id
    ).pluck_h(*_sum_fields).pop.try(:reject){|_,v|
      v.blank?
    }
  end
end