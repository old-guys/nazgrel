class Dev::Report::ShopEcnsController < Dev::Report::BaseController
  include ActionSearchable
  include ActionExportable

  def index
    @report_shop_ecns = ReportShopEcn.preload(:shop, :shopkeeper, :channel)

    @shopkeeper_query = shopkeeper_params.select{|_,v| v.presence }
    if @shopkeeper_query.present?
      @report_shop_ecns = @report_shop_ecns.joins(:shop).where(
        shop_id: Shopkeeper.where(@shopkeeper_query).select(:shop_id)
      )
    end
    if params[:created_at].present?
      _dates = range_within_datetime(str: params[:created_at])

      @report_shop_ecns = @report_shop_ecns.joins(:shop).where(shops: {created_at: _dates})
    end

    preload_export(service: 'Dev::ShopEcn', action: 'report', relation: @report_shop_ecns)

    @report_shop_ecns = filter_by_pagination(relation: @report_shop_ecns, default_per_page: 50)
  end

  private
  def shopkeeper_params
    params.fetch(:shopkeeper, {}).permit(
      :id,
      :user_id, :user_phone
    )
  end
end