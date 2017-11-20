class ApiKey < ApplicationRecord
  belongs_to :user

  include ApiKeyable
  api_key_on(column: :user_id)
end
