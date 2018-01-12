json.partial! 'api/shared/paginator', records: @report_shop_ecns

json.cache! ['api/web/report/shop_ecns', @report_shop_ecns] do
  json.models do
    json.cache_collection! @report_shop_ecns.to_a, key: 'api/web/shop_ecns/show' do |record|
      json.partial! 'api/web/report/shop_ecns/show', locals: { record: record }
    end
  end
end