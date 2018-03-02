class DailyOperational::Reporting
  class << self
    delegate :update_report, to: "DailyOperational::UpdateReport"
  end
end