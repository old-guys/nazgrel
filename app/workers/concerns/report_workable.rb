module ReportWorkable
  extend ActiveSupport::Concern

  included do
    include ReportLoggerable
  end

  module ClassMethods
  end
end