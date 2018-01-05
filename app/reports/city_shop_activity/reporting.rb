class CityShopActivity::Reporting
  class << self
    delegate :update_report, to: "CityShopActivity::UpdateReport"
  end
end