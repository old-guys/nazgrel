class ProductRepurchase::Reporting
  class << self
    delegate :update_week_report, :update_month_report, to: "ProductRepurchase::UpdateReport"
  end
end