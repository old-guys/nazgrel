json.array! @result do |item|
  json.(item, *item.keys)
end