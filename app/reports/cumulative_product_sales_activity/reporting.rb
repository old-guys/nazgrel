class CumulativeProductSalesActivity::Reporting
  class << self
    delegate :update_report, to: "CumulativeProductSalesActivity::UpdateReport"
  end
end