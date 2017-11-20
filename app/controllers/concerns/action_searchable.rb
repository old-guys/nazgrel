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
    _parse_service = FilterParserService.new(
      relation: relation, filters: search_filters
    )

    _parse_service.parse
  end

  def filter_by_pagination(relation: )
    params[:per_page] ||= Kaminari.config.default_per_page

    relation = relation.page(params[:page]).per(params[:per_page])
  end

  private
  def search_params
    @search_params ||= params.except(:page, :per_page)
  end

  def search_filters
    search_params[:filters] || []
  end
end