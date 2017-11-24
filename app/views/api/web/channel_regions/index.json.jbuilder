json.partial! 'api/shared/paginator', records: @channel_regions
json.models @channel_regions do |record|
  json.partial! 'api/web/channel_regions/show', locals: { record: record }

  json.channel_users do
    json.partial! 'api/web/channel_users/show', collection: record.channel_users, as: :record
  end
end
