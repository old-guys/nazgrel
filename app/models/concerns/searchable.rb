module Searchable
  extend ActiveSupport::Concern

  included do
    class_attribute :search_fields, :search_joins

    scope :simple_search, -> (query) {
      _all = all
      _search_fields = search_fields.dup

      _records = default_scoped

      if _search_fields.present?
        _records = _records.where(
          "#{_search_fields.shift} like ?", "%#{query}%"
        )
        _search_fields.each{|field|
          _records = _records.or(default_scoped.where("#{field} like ?", "%#{query}%"))
        }
      end

      _all.joins(search_joins).merge(_records)
    }
  end

  private
  module ClassMethods
    def simple_search_on(fields: , joins: nil)
      self.search_fields ||= []
      self.search_fields = search_fields.concat(Array.wrap(fields)).uniq

      self.search_joins ||= []
      self.search_joins = search_joins.concat(Array.wrap(joins)).uniq
    end
  end
end