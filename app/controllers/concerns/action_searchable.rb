module ActionSearchable
  extend ActiveSupport::Concern

  included do
  end
  def distance_of_time_range(str: , from_time: nil)
    from_time ||= Time.now

    case str.to_s
      when /\d+_day_ago/, /\d+_month_ago/, /\d+_year_ago/
        _str_values = str.split("_")
        _str_values[0].to_i.send(_str_values[1]).ago(from_time)..from_time
    end
  end

  def parse_datetime(str: )
    Time.parse(str)
  end

  def range_within_datetime(str: )
    if str.include?("..")
      _values = str.split("..")

      parse_datetime(str: _values[0])..parse_datetime(str: _values[1])
    else
      parse_datetime(str: str).all_day
    end
  end

  def range_within_date(str: )
    return if str.blank?

    if str.include?("..")
      _values = str.split("..")

      Date.parse(_values[0])..Date.parse(_values[1])
    else
      Date.parse(str)
    end
  end

  def range_within_number(str: )
    _values = str.split("..")

    if str.include?("..")
      _values = str.split("..")

      _values[0].to_d.._values[1].to_d
    else
      str.to_s
    end
  end

  # records, [{
  #   name: "created_at", field_type: "datetime",
  #   operator: "within", query: "today"
  # }]
  # records, [{
  #   name: "created_at", field_type: "datetime",
  #   operator: "within",
  #   query: [
  #     "2017-11-13T16:25:09+08:00",
  #     "2017-11-17T16:25:09+08:00"
  #   ]]
  # }]
  def filter_records_by(relation: )
    return relation if search_filters.blank?

    _parse_service = FilterParserService.new(
      relation: relation, filters: search_filters
    )

    _parse_service.parse
  end

  def filter_by_pagination(relation: , default_per_page: Kaminari.config.default_per_page)
    params[:per_page] ||= default_per_page

    relation = relation.page(params[:page]).per(params[:per_page])
  end

  def sort_records(relation: )
    if search_params[:order].present?
      _order_options = search_params[:order].split(",").map(&:presence)

      _order_options.map!{|order|
        options = order.split(" ").map(&:presence)
        _column = options[0].include?(".") ? options[0] : "`#{relation.klass.table_name}`.`#{options[0]}`"
        _sort = options[1].to_s.upcase

        "#{_column} #{_sort}"
      }
    end

    if relation.order_values.blank?
      _order_options ||= {relation.klass.primary_key => :desc}
    end

    _order_options.present? ? relation.order!(_order_options) : relation
  end

  def simple_search(relation: )
    return relation if search_params[:query].blank?

    relation = relation.simple_search(search_params[:query])
  end

  private
  def search_params
    @search_params ||= params.except(:page, :per_page)
  end

  def search_filters
    _filters = if params[:json_key].to_s.include?("filters")
      JSON.parse(search_params[:filters]) rescue []
    else
      search_params[:filters] || []
    end
    _filters = [] if not _filters.is_a?(Array)

    _filters
  end
end