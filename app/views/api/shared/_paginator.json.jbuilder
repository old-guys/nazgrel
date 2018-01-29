cached = records.group_values.present? ? false : true
json.cache_if! cached, ['api/shared/paginator', records] do
  json.total_count records.try(:total_count) || 0
  json.total_pages records.try(:total_pages)

  json.current_page records.try(:current_page)
  json.next_page records.try(:next_page)
  json.prev_page records.try(:prev_page)
  json.first_page? records.try(:first_page?)
  json.last_page? records.try(:last_page?)
  json.per_page (params[:per_page]).to_i
  json.page (params[:page]).to_i
end