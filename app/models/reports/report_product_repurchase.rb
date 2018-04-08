class ReportProductRepurchase < ApplicationRecord
  belongs_to :category, required: false

  scope :week, ->() {
    where("DATEDIFF(end_at, start_at) = 7")
  }
  scope :month, ->() {
    where("DATEDIFF(end_at, start_at) BETWEEN 28 AND 31")
  }
end