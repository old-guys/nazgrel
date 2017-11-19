json.total_count records.try(:total_count) || 0
json.per_page (params[:per_page]).to_i
json.page (params[:page]).to_i
