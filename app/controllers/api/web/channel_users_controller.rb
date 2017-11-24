class Api::Web::ChannelUsersController < Api::Web::BaseController
  include ActionSearchable

  def index
    @channel_users = ::ChannelUser.order(id: :desc)
    if params[:channel_id]
      @channel_users = @channel_users.where(channel_id: params[:channel_id])
    end

    @channel_users = filter_by_pagination(relation: @channel_users)
  end

  def show
    @channel_user = ::ChannelUser.find(params[:id])
  end

  def create
    if not channel_user_params[:role_type].to_s.in?(ChannelUser.role_types.keys)
      raise Errors::InvalidParameterError.new("无效的角色类型")
    end
    if channel_user_params[:role_type] == "manager"
      build_manager_channel_user
    end
    if channel_user_params[:role_type] == "normal_user"
      build_normal_channel_user
    end
    if channel_user_params[:role_type] == "region_manager"
      build_region_manager_channel_user
    end

    if @channel_user.save
      render :show
    else
      raise ActiveRecord::RecordInvalid.new(@channel_user)
    end
  end

  def update
    @channel_user = ::ChannelUser.find(params[:id])

    if @channel_user.update(channel_user_params)
      render :show
    else
      raise ActiveRecord::RecordInvalid.new(@channel_user)
    end
  end

  def destroy
    @channel_user = ::ChannelUser.find(params[:id])
    @channel_user.destroy

    render :show
  end

  private
  def build_normal_channel_user
    @channel = ::Channel.find_by(id: params[:channel_id])
    if @channel.blank?
      raise Errors::InvalidParameterError.new("无效的渠道")
    end

    @channel_user = @channel.channel_users.new(channel_user_params)
    # REVIEW 渠道新增普通用户应该限定为其下级店主
    _shopkeeper = @channel.shopkeepers.find_by(user_id: channel_user_params[:shopkeeper_user_id])

    if _shopkeeper.present?
      raise Errors::InvalidParameterError.new("无效的店主用户ID")
    else
      _attrs = {
        phone: _shopkeeper.user_phone,
        shop_id: _shopkeeper.shop_id
      }
      @channel_user.name = _shopkeeper.user_name if @channel_user.name.blank?

      @channel_user.assign_attributes(_attrs)
    end
  end
  def build_manager_channel_user
    @channel = ::Channel.find_by(id: params[:channel_id])
    @channel_user = @channel.channel_users.new(channel_user_params)

    if @channel.blank?
      raise Errors::InvalidParameterError.new("无效的渠道")
    end
  end

  def build_region_manager_channel_user
    @channel_region = ::ChannelRegion.find_by(id: params[:channel_region_id])
    @channel_user = @channel_region.channel_users.new(
      channel_user_params
    )

    if @channel_region.blank?
      raise Errors::InvalidParameterError.new("无效的渠道大区")
    end
  end

  def channel_user_params
    params.require(:channel_user).permit(
      :name, :phone, :password,
      :role_type,
      :shopkeeper_user_id, :shop_id
    )
  end
end
