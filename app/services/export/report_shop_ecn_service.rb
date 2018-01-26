module Export
  class ReportShopEcnService

    include Export::BaseService
    include ActionView::Helpers::NumberHelper

    def index_fields
      %w(
        id shopkeeper.to_s shop.to_s shopkeeper.user_phone
        ecn_count ancestry_rate ecn_grade_platinum_count ecn_grade_gold_count
        children_grade_platinum_count children_grade_gold_count
        indirectly_descendant_grade_platinum_count indirectly_descendant_grade_gold_count
        channel.to_s
      )
    end

    def index_head_names
      %w(
        序号 店主名称 店铺名称 手机号 ECN总数 上级总数占比 ECN-白金 ECN-黄金
        直接-白金总数 直接-黄金总数 间接-白金总数 间接-黄金总数 所属渠道
      )
    end

    def index_record_ancestry_rate(record)
      record.ancestry_rate.blank? ? nil : number_to_percentage(record.ancestry_rate * 100, precision: 1)
    end

  end
end
