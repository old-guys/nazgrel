json.(record, :id, :shop_id)

_stages = %w(day_0 day_7 day_30 total)
ReportCumulativeShopActivity.stat_categories.each {|category|
  _stages.each {|stage|
    json.(record, "#{stage}_#{category}")
  }
}

json.(record, :created_at, :updated_at)