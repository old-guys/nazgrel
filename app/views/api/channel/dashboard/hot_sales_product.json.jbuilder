json.today @result[:today] do |data|
  json.(data, :index, :product_name, :product_id, :product_num)
end
