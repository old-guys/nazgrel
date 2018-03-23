class DailyShopGradeOperational::Reporting
  class << self
    delegate :update_report, to: "DailyShopGradeOperational::UpdateReport"
  end
end