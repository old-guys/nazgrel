class Api::Web::ChannelUsersController < Api::Web::BaseController
  include ActionSearchable

  def index
    @channel_users = ::ChannelUser.order(id: :desc)

    @channel_users = filter_by_pagination(relation: @channel_users)
  end

  def show
    @channel_user = ::ChannelUser.find(params[:id])
  end

  def create
    @channel = ::Channel.find_by(id: params[:channel_id])
    if @channel.blank?
      raise Errors::InvalidParameterError.new("无效的渠道")
    end

    @channel_user = @channel.channel_users.new(channel_user_params)
    _shopkeeper = Shopkeeper.find_by(user_id: channel_user_params[:shopkeeper_user_id])

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
  def channel_user_params
    params.require(:channel_user).permit(
      :name, :phone, :password,
      :role_type,
      :shopkeeper_user_id
    )
  end
end
