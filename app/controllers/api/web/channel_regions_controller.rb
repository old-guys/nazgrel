class Api::Web::ChannelRegionsController < Api::Web::BaseController
  include ActionSearchable

  #
  # filters: [{
  #   name: "status", field_type: "integer",
  #   operator: "eq", query: "0"
  # }],
  # order: "id desc",
  # query: "测试"
  def index
    @channel_regions = ::ChannelRegion.preload(
      :channel_users,
      channel_channel_region_maps: [
        channel: [:own_shop, :own_shopkeeper, :channel_users]
      ]
    ).order(id: :desc)

    @channel_regions = filter_records_by(relation: @channel_regions)
    @channel_regions = simple_search(relation: @channel_regions)
    @channel_regions = sort_records(relation: @channel_regions)
    @channel_regions = filter_by_pagination(relation: @channel_regions)
  end

  def show
    @channel_region = ::ChannelRegion.preload(
      :channel_users,
      channel_channel_region_maps: [
        channel: [:own_shop, :own_shopkeeper, :channel_users]
      ]
    ).find(params[:id])
  end

  def create
    @channel_region = ::ChannelRegion.new(channel_region_params.except(:channel_user))

    _channel_user = ChannelUser.manager.where(
      phone: channel_region_params[:channel_user][:phone]
    ).first_or_initialize
    _channel_user.assign_attributes(
      channel_region_params[:channel_user].except(:phone).reverse_merge(
        role_type: :region_manager
      )
    )
    @channel_region.channel_users << _channel_user

    if @channel_region.save
      render :show
    else
      raise ActiveRecord::RecordInvalid.new(@channel_region)
    end
  end

  def destroy_channel
    @channel_region = ::ChannelRegion.find(params[:id])

    channel_region_maps = @channel_region.channel_channel_region_maps.where(channel_id: params[:channel_id])
    if channel_region_maps.destroy_all
      render :show
    else
      raise ActiveRecord::RecordInvalid.new(@channel_region)
    end
  end

  def update
    @channel_region = ::ChannelRegion.find(params[:id])

    if @channel_region.update(channel_region_params.except(:channel_user))
      render :show
    else
      raise ActiveRecord::RecordInvalid.new(@channel_region)
    end
  end

  private
  def channel_region_params
    params.require(:channel_region).permit(
      :name, :status, :area, channel_user: [
        :name, :role_type, :phone, :password
      ], channel_ids: []
    )
  end
end