module OperationalCumulativeShopActivitySummary::Calculations

  def calculate(date: )
    result = {}
    _stages = %w{
      week_1 month_1 month_3
      month_6 year_1
    }
    _stages.each {|stage|
      result.merge!(calculate_by_stage(date: date, stage: stage))
    }

    result
  end

  private
  def calculate_by_stage(date: , stage: )
    _unit, _number = stage.split("_")
    _dates = _number.to_i.send(_unit).ago(date)..date

    _counts = Shopkeeper.where(
      shop_id: ReportShopActivity.where(
        report_date: _dates
      ).where(
        "`report_shop_activities`.`order_number` > ?", 0
      ).select(:shop_id)
    ).group("`shopkeepers`.`user_grade`").count

    result = {
      "#{stage}_total_count": _counts.values.sum
    }
    Shopkeeper.user_grades.each {|key, value|
      result.merge!("#{stage}_#{key}_count": _counts[value].to_i)
    }

    result
  end
end