# encoding: utf-8

class Utility
  class << self
    # as_json convert nil to ""
    def as_json(origin_hash = {})
      origin_hash.inject({}) do |new_hash, (k,v)|
        unless v.nil?
          new_hash[k] = v.class.eql?(Hash) ? as_json(v) : v
        else
          new_hash[k] = ""
        end
        new_hash
      end
    end

    def simple_batch_operate(relation, batch_size: 50000, sleep_time: 0.2)
      records = relation.unscope(:order)

      _edge_ids = [records.klass.minimum(:id).to_i, records.klass.maximum(:id).to_i]
      _id = _edge_ids.first

      while
        _id_offset = _id + batch_size
        puts "_id_offset: #{_id_offset}"

        _records = records.where(id: _id.._id_offset)

        if block_given?
          yield _records

          sleep sleep_time
        end

        break if _id_offset > _edge_ids.last

        _id = _id_offset
      end
    end

    def where_sql_str(sql)
      sql_str = sql.respond_to?(:to_sql) ? sql.unscope(:order, :limit, :offset, :group).to_sql : sql

      sql_str.slice((sql_str.index(/where /i) + 5)..-1).strip
    end
  end
end
