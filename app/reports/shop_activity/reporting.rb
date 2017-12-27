class ShopActivity::Reporting
  class << self
    delegate :update_report, to: "ShopActivity::UpdateReport"
  end
end