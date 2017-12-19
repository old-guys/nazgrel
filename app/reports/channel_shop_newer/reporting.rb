class ChannelShopNewer::Reporting
  class << self
    delegate :update_report, to: "ChannelShopNewer::UpdateReport"
    delegate :reset_report, to: "ChannelShopNewer::ResetReport"
  end
end