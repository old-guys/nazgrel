  json.partial! 'api/web/channel_regions/show', locals: { record: @channel_region }

  json.channel_user do
    if @channel_region.channel_users
      json.partial! 'api/web/channel_users/show', collection: @channel_region.channel_users, as: :record
    end
  end
