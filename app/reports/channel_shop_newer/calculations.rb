module ChannelShopNewer::Calculations
  def aggregation_by_day(records:, dates: )
    start_date = dates.first.to_date
    end_date = dates.last.to_date

    start_date.upto(end_date).map {|date|
      _data = records.select{|item|
        item.created_at.in? date.to_time.all_day
      }

      _daily_result = {
        stage_1_grade_platinum: _data.select{|item|
          item.user_grade == "grade_platinum" && item.created_at.hour.in?(0..8)
        }.count,
        stage_1_grade_gold: _data.select{|item|
          item.user_grade == "grade_gold" && item.created_at.hour.in?(0..8)
        }.count,
        stage_2_grade_platinum: _data.select{|item|
          item.user_grade == "grade_platinum" && item.created_at.hour.in?(9..17)
        }.count,
        stage_2_grade_gold: _data.select{|item|
          item.user_grade == "grade_gold" && item.created_at.hour.in?(9..17)
        }.count,
        stage_3_grade_platinum: _data.select{|item|
          item.user_grade == "grade_platinum" && item.created_at.hour.in?(18..23)
        }.count,
        stage_3_grade_gold: _data.select{|item|
          item.user_grade == "grade_gold" && item.created_at.hour.in?(18..23)
        }.count,

        day_grade_platinum: _data.select{|item|
          item.user_grade == "grade_platinum"
        }.count,
        day_grade_gold: _data.select{|item|
          item.user_grade == "grade_gold"
        }.count
      }

      {
        report_date: date,
        result: _daily_result
      }
    }
  end

  def aggregation_by_month(result: )
    result.map! {|item|
      _result = result.select{|month_item|
        month_item[:report_date] <= item[:report_date] &&
        month_item[:report_date].month == item[:report_date].month
      }

      item[:result][:month_grade_platinum] = _result.pluck(:result).flatten.pluck(:stage_1_grade_platinum,
        :stage_2_grade_platinum, :stage_3_grade_platinum
      ).flatten.sum

      item[:result][:month_grade_gold] = _result.pluck(:result).flatten.pluck(:stage_1_grade_gold,
        :stage_2_grade_gold, :stage_3_grade_gold
      ).flatten.sum

      item
    }
  end

  def aggregation_by_year(result: )
    result.map! {|item|
      _result = result.select{|month_item|
        month_item[:report_date] <= item[:report_date] &&
        month_item[:report_date].year == item[:report_date].year
      }

      item[:result][:year_grade_platinum] = _result.pluck(:result).flatten.pluck(:stage_1_grade_platinum,
        :stage_2_grade_platinum, :stage_3_grade_platinum
      ).flatten.sum

      item[:result][:year_grade_gold] = _result.pluck(:result).flatten.pluck(:stage_1_grade_gold,
        :stage_2_grade_gold, :stage_3_grade_gold
      ).flatten.sum

      item
    }
  end

  def calculate(channel: , dates: Time.now.all_year)
    records = channel.shopkeepers.where(created_at: dates).pluck_s(
      :user_grade,
      :created_at
    )

    result = aggregation_by_day(records: records, dates: dates)
    aggregation_by_month(result: result)
    aggregation_by_year(result: result)

    result
  end

  def calculate_by_day(channel: , dates: Time.now.all_day)
    records = channel.shopkeepers.where(created_at: dates).pluck_s(
      :user_grade,
      :created_at
    )

    result = aggregation_by_day(records: records, dates: dates)

    result
  end
end