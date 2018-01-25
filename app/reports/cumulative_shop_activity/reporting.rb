class CumulativeShopActivity::Reporting
  class << self
    delegate :update_report, to: "CumulativeShopActivity::UpdateReport"
  end
end