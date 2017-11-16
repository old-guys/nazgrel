class ApiKey < ApplicationRecord
  belongs_to :user

  include ApiKeyable
end
