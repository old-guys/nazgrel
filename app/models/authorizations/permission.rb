class Permission < ApplicationRecord
  validates :name, :subject, presence: true
  validates :uid, presence: true, uniqueness: true
end