class Role < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_and_belongs_to_many :users
  has_and_belongs_to_many :permissions
end