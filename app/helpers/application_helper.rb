module ApplicationHelper
  def format_numberlize(value: )
    case value.class.to_s
      when "Float"
        value.round(3)
      when "BigDecimal"
        number_to_currency value, unit: ""
      else
        value
    end
  end
end