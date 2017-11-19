class FilterParserService
  attr_accessor :relation, :filters, :table_name

  delegate :parse_operator, :parse_query_value, :build_conds, to: "self.class"

  def initialize(attrs = {})
    @relation = attrs[:relation]
    @filters = attrs[:filters].deep_dup
    @table_name = @relation.table_name
  end

  def parse
    @filters.each do |filter|
      filter = OpenStruct.new(filter)
      operator = parse_operator(filter[:operator])

      if filter.joins
        @relation = @relation.joins(filter.joins)
      end
      query_name = parse_query_name(filter)
      @relation = @relation.where(*build_conds(query_name, operator, filter))
    end

    @relation
  end

  def parse_query_name(filter)
    filter[:column].presence || "`#{@table_name}`.`#{filter[:name]}`"
  end

  class << self
    def operators_i18n
      {
        equal: "等于",
        eq: "等于",
        ne: '不等于',
        in: "等于",
        multi_in: '包含',
        contain: '包含',
        like: '包含',
        not_contain: '不包含',
        not_like: '不包含',
        gt: "大于",
        gte: "大于等于",
        lt: "小于",
        lte: "小于等于",
      }.freeze
    end

    def parse_operator(operator)
      case operator.downcase
        when 'contain', 'like'
          'like'
        when 'equal', 'eq'
          '='
        when 'ne'
          '!='
        when 'gt'
          ">"
        when 'gte'
          ">="
        when 'lt'
          "<"
        when "lte"
          '<='
        when "in"
          'in'
        when "nin"
          'not in'
        when "not_contain", 'not_like'
          'not like'
        when 'start_with'
          'like'
        when 'non_start_with'
          'not REGEXP'
        when 'within'
          'between'
      end
    end

    def parse_query_value(filter_operator, query, filter = {})
      case filter_operator.downcase
        when 'contain', 'like', 'not_contain', 'not_like'
          "%#{query}%"
        when 'equal', "eq"
          query
        when 'start_with'
          "#{query}%"
        when 'within'
          case query
            when 'today'
              [Time.now.beginning_of_day, Time.now.end_of_day]
            when 'tomorrow'
              [1.days.since.beginning_of_day, 1.days.since.end_of_day]
            when 'yesterday'
              [1.days.ago.beginning_of_day, 1.days.ago.end_of_day]
            when 'week'
              [Time.now.beginning_of_week, Time.now.end_of_week]
            when 'month'
              [Time.now.beginning_of_month, Time.now.end_of_month]
            when 'quarter'
              [Time.now.beginning_of_quarter, Time.now.end_of_quarter]
            when 'year'
              [Time.now.beginning_of_year, Time.now.end_of_year]
            when 'last_week'
              [1.weeks.ago.beginning_of_week, 1.weeks.ago.end_of_week]
            when 'last_month'
              [1.month.ago.beginning_of_month, 1.month.ago.end_of_month]
            when 'next_week'
              [Time.now.next_week.beginning_of_week, Time.now.next_week.end_of_week]
            when 'next_month'
              [Time.now.next_month.beginning_of_month,  Time.now.next_month.end_of_month]
            when 'next_week_to_today'
              [Time.now.beginning_of_week,  Time.now.end_of_day]
            when 'this_month_to_today'
              [Time.now.beginning_of_month,  Time.now.end_of_day]
            when /^\d*_days\Z/
              day = query.gsub("_days","").to_i
              [Time.now, day.days.from_now]
            when /^\d*_days_ago\Z/
              day = query.gsub("_days_ago","").to_i
              [day.days.ago, Time.now]
            when Array
              _query = query.map(&:to_s)
              date_regex = /^\d{4}-\d{2}-\d{2}$/

              _query[0] = _query[0].match(date_regex) ? Time.parse(_query[0]).beginning_of_day : Time.parse(_query[0])
              _query[1] = _query[1].match(date_regex) ? Time.parse(_query[1]).end_of_day : Time.parse(_query[1])

              _query
          end
        when 'non_start_with'
          "^[A-Za-z]"
        when "ne", "lt", "lte", "gt", "gte"
          query
        when "in", "nin"
          Array.wrap(query)
        when 'birth_day'
          # ["within_今天", "within_明天", "within_本周", "within_下周", "within_本月", "within_下月"]
          case query
            when 'within_today'
              {format: '%m-%d', query: Date.today.strftime("%m-%d") }
            when 'within_tomorrow'
              {format: '%m-%d', query: 1.days.since.strftime("%m-%d") }
            when 'within_this_week'
              _query = (Date.today.at_beginning_of_week..Date.today.at_end_of_week).map { |day| day.strftime("%m-%d") }

              {format: '%m-%d', query: _query}
            when 'within_next_week'
              _query = (Date.today.next_week.at_beginning_of_week..Date.today.next_week.at_end_of_week).map { |day| day.strftime("%m-%d") }

              {format: '%m-%d', query: _query}
            when 'within_this_month'
              {format: '%m', query: Date.today.month}
            when 'within_next_month'
              {format: '%m', query: Date.today.next_month.month}
            when /\d/
              {format: '%m', query: query}
            when Array
              _query = (query[0].to_date..query[1].to_date).map { |day| day.strftime("%m-%d") }

              {format: '%m-%d', query: _query}
          end
      end
    end

    def build_conds(query_name, operator, filter)
      case filter[:operator]
        when 'within'
          ["#{query_name} between ? and ?", *parse_query_value(filter[:operator], filter[:query], filter)]
        when "in"
          ["#{query_name} #{operator} (?)", parse_query_value(filter[:operator], filter[:query], filter)]
        when "nin"
          ["#{query_name} is null or #{query_name} #{operator} (?)", parse_query_value(filter[:operator], filter[:query], filter)]
        when "eq"
          _query_str = filter[:query].eql?("null") ? "#{query_name} is null" : "#{query_name} #{operator} (?)"

          [_query_str, parse_query_value(filter[:operator], filter[:query], filter)]
        when "ne"
          _query_str = filter[:query].eql?("null") ? "#{query_name} is not null" : "#{query_name} #{operator} (?)"

          [_query_str, parse_query_value(filter[:operator], filter[:query], filter)]
        when "birth_day"
          ["DATE_FORMAT(#{query_name}, :format) in (:query)", parse_query_value(filter[:operator], filter[:query], filter)]
        else
          ["#{query_name} #{operator} ?", parse_query_value(filter[:operator], filter[:query], filter)]
      end
    end
  end
end
