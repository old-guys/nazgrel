module ReportCalculationable
  extend ActiveSupport::Concern

  included do
  end

  private
  def format_calculate_hash(result: nil)
    return if result.blank?

    result.each {|k, v| result[k] ||= 0 }
    result
  end

  module ClassMethods
  end
end