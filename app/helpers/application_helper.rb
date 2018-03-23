module ApplicationHelper
  def format_numberlize(value: , field: nil)
    case value.class.to_s
      when "Float"
        field.to_s.end_with?("_rate") ? number_to_percentage(value.round(3) * 100, precision: 1) : value.round(3)
      when "BigDecimal"
        number_to_currency value, unit: ""
      else
        value
    end
  end
end