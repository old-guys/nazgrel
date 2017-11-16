class ChannelApiKey < ApplicationRecord
  belongs_to :channel_user

  include ApiKeyable
end
