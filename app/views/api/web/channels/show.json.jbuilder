  json.partial! 'api/web/channels/show', locals: { record: @channel }

  json.channel_user do
    if @channel.channel_user
      json.partial! 'api/web/channel_users/show', locals: { record: @channel.channel_user }
    end
  end
