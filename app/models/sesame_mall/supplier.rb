class Supplier < ApplicationRecord
  enum status: {
    normal: 0,
    locked: 1
  }

  def to_s
    name
  end
end