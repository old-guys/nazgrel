module ReportShopActivityable
  extend ActiveSupport::Concern

  included do
  end


  private
  module ClassMethods
    def stat_categories
      @stat_categories ||= %w(
        shared_count view_count viewer_count order_number shopkeeper_order_number
        sale_order_number order_amount shopkeeper_order_amount
        sale_order_amount children_grade_platinum_count
        children_grade_gold_count ecn_grade_platinum_count
        ecn_grade_gold_count
      ).freeze
    end

    def stat_fields
      @stat_fields ||= proc {
        _dimensions = [
          nil, "stage_1", "stage_2", "stage_3",
          "week", "month", "year"
        ]
        stat_categories.map {|category|
          _dimensions.map{|dimension|
            dimension ? "#{dimension}_#{category}" : category
          }
        }.flatten.freeze
      }.call
    end
  end
end