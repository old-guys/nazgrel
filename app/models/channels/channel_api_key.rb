class ChannelApiKey < ApplicationRecord
  belongs_to :channel_user

  include ApiKeyable
  api_key_on(column: :channel_user_id)
end
