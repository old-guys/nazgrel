class Api::Web::Report::ShopEcnsController < Api::Web::BaseController
  include ActionSearchable

  def index
    @report_shop_ecns = ReportShopEcn.preload(:shop, :shopkeeper, :channel)

    if params[:ecn_count].present?
      _ecn_count = range_within_number(str: params[:ecn_count])
      @report_shop_ecns = @report_shop_ecns.where(ecn_count: _ecn_count)
    end

    _shopkeeper_query = shopkeeper_params.select{|_,v| v.presence }
    if _shopkeeper_query.present?
      @report_shop_ecns = @report_shop_ecns.where(shop_id:
        Shopkeeper.where(_shopkeeper_query).select(:shop_id)
      )
    end
    if params[:created_at].present?
      _dates = range_within_datetime(str: params[:created_at])

      @report_shop_ecns = @report_shop_ecns.where(shops: {created_at: _dates})
    end

    @report_shop_ecns = filter_by_pagination(relation: @report_shop_ecns)
  end

  private
  def shopkeeper_params
    params.fetch(:shopkeeper, {}).permit(
      :user_id, :user_name, :user_phone
    )
  end
end