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

    # method such as 'Hash#deep_transform_keys'
    # Utility.deep_transform_values({a: 1, b: {c: nil, d: 1}, e: nil}) {|v| "#{v}"}
    def deep_transform_values(origin_hash = {}, &proc)
      if origin_hash and block_given?
        origin_hash.inject({}) do |new_hash, (k,v)|
          if v.class.eql?(Hash)
            new_hash[k] = self.send(:deep_transform_values, v, &proc)
          else
            #new_hash[k] = yield v
            new_hash[k] = proc.call(v)
          end
          new_hash
        end
      else
        origin_hash
      end
    end

    def as_json_nil_to_string(origin_hash = {})
      deep_transform_values(origin_hash) {|v| v.nil? ? "" : v }
    end

    def add_params_to_url(url, path, params)
      if url.present? and params.present?
        uri = URI(url)
        query_hash = Rack::Utils.parse_query(uri.query)
        query_hash.merge!(params)
        #uri.query = Rack::Utils.build_query(query_hash) #cannot use to nest_hash
        uri.query = query_hash.to_param
        uri.path = path
        uri.to_s
      end
    end

    # return an hash include version regex string to match older version
    def version_hash(version)
      if version.present?
        version_list = version.split('.')
        version_hash = {}

        #major_regex
        version_hash.merge!(major: version_list[0].to_i)
        #minor_regex
        version_hash.merge!(minor: version_list[1].to_i)
        # build_regex
        version_hash.merge!(build: version_list[2].to_i)
        version_hash
      end
    end

    # is version old than match_version? return true or false
    def is_old_version?(version, match_version)
      if version.present? and match_version.present?
        _current_version_hash = version_hash(version)
        _match_version_hash = version_hash(match_version)

        [:major, :minor, :build].each{|k|
          return false if  _current_version_hash[k] >= _match_version_hash[k]
        }

        true
      end
    end

    def where_sql_str(sql)
      sql_str = sql.respond_to?(:to_sql) ? sql.unscope(:order, :limit, :offset, :group).to_sql : sql

      sql_str.slice((sql_str.index(/where /i) + 5)..-1).strip
    end
  end
end
