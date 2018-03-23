class ShopRetention::Reporting
  class << self
    delegate :update_report, to: "ShopRetention::UpdateReport"
  end
end