json.(record, :id, :shop_id)

ReportShopActivity.stat_categories.each {|category|
  json.(record, :"week_#{category}")
  json.(record, :"month_#{category}")
}

json.(record, :created_at, :updated_at)