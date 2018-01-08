class ChannelShopActivity::Reporting
  class << self
    delegate :update_report, to: "ChannelShopActivity::UpdateReport"
  end
end