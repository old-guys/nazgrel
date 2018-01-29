module ReportCumulativeShopActivityable
  extend ActiveSupport::Concern

  included do
    include ReportShopActivityable

    class << self
      def stat_fields
        @stat_fields ||= proc {
          stat_categories.map {|category|
            stat_cumulative_stages.map{|stage|
              "#{stage}_#{category}"
            }
          }.flatten.freeze
        }.call
      end
    end
  end


  private
  module ClassMethods
    def stat_cumulative_stages
      @stat_cumulative_stages ||= %w(
        day_0 day_3 day_7
        day_15 day_30 day_60
      ).freeze
    end
  end
end