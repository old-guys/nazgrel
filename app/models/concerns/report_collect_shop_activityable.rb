module ReportCollectShopActivityable
  extend ActiveSupport::Concern

  included do
    include ReportShopActivityable

    class << self
      def stat_categories
        super.reject{|category|
          category =~ /children|descendant/
        }.freeze
      end

      def stat_fields
        @stat_fields ||= proc {
          stat_categories.map {|category|
            stat_stages.map{|stage|
              stage ? "#{stage}_#{category}" : category
            }
          }.flatten.freeze
        }.call
      end
    end
  end


  private
  module ClassMethods

  end
end