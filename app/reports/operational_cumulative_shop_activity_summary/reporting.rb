class OperationalCumulativeShopActivitySummary::Reporting
  class << self
    delegate :update_report, to: "OperationalCumulativeShopActivitySummary::UpdateReport"
  end
end