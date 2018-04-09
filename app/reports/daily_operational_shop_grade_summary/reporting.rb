class DailyOperationalShopGradeSummary::Reporting
  class << self
    delegate :update_report, to: "DailyOperationalShopGradeSummary::UpdateReport"
  end
end