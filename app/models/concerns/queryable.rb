module Queryable
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def limit_within_group(records: , rating_name: , sort: , limit: 1)
      select("*").from(Arel.sql(%Q{
        (
          SELECT
              *,
              @rn := CASE WHEN @prev_rating_name = #{rating_name} THEN @rn + 1 ELSE 1 END AS rn,
              @prev_rating_name := #{rating_name}
          FROM (
            #{records.to_sql}
          ) AS T1, (SELECT @prev_rating_name := '', @rn := 0) AS vars
          ORDER BY #{sort}
        ) T2
      })).where("rn <= #{limit}").order("#{sort}")
    end
  end
end