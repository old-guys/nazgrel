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

  class << self
    def select_options
      Rails.cache.fetch("select_options:#{all.cache_key}") {
        pluck(:name, :id)
      }
    end
  end
end