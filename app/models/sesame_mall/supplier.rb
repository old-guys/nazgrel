class Supplier < ApplicationRecord
  enum status: {
    normal: 0,
    locked: 1
  }

  include Searchable

  simple_search_on fields: [
    :name
  ]

  def to_s
    name
  end

end