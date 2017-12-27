class ReportShopActivity::Reporting
  class << self
    delegate :update_report, to: "ReportShopActivity::UpdateReport"
  end
end