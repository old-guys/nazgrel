class ShopEcn::Reporting
  class << self
    delegate :update_report, to: "ShopEcn::UpdateReport"
  end
end