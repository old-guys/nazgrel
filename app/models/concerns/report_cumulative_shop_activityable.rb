module ReportCumulativeShopActivityable
  extend ActiveSupport::Concern

  included do
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