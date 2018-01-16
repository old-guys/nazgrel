json.cache! ['api/open/mobile/shop_activities/show', @report_shop_activities] do
  json.view_count @report_shop_activities.map(&:view_count).compact.sum
  json.shared_count @report_shop_activities.map(&:shared_count).compact.sum
  json.viewer_count @report_shop_activities.map(&:viewer_count).compact.sum

  json.details do
    json.array! @date_range.to_a do |date|
      _record = @report_shop_activities.find{|record| record.report_date == date }
      json.date date
      json.view_count _record.try(:view_count) || 0
      json.shared_count _record.try(:shared_count) || 0
      json.viewer_count _record.try(:viewer_count) || 0
    end
  end
end