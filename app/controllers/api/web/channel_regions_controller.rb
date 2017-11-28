class Api::Web::ChannelRegionsController < Api::Web::BaseController
  include ActionSearchable

  def index
    @channel_regions = ::ChannelRegion.preload(:channel_users).order(id: :desc)

    @channel_regions = filter_by_pagination(relation: @channel_regions)
  end

  def show
    @channel_region = ::ChannelRegion.find(params[:id])
  end

  def create
    @channel_region = ::ChannelRegion.new(channel_region_params.except(:channel_user))
    @channel_region.channel_users.new(channel_region_params[:channel_user])

    if @channel_region.save
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
