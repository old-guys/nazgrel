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
    end
  end


  private
  module ClassMethods

  end
end