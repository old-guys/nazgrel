class ReportProductRepurchase < ApplicationRecord
  belongs_to :category, required: false
end