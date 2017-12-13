module ActionSearchable
  extend ActiveSupport::Concern

  included do
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

  def filter_by_pagination(relation: )
    params[:per_page] ||= Kaminari.config.default_per_page

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