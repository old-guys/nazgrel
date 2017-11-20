class Api::Web::ChannelsController < Api::Web::BaseController
  include ActionSearchable

  def index
    @channels = ::Channel.order(id: :desc)

    @channels = filter_by_pagination(relation: @channels)
  end

  def show
    @channel = ::Channel.find(params[:id])
  end

  def create
    @channel = ::Channel.new(channel_params.except(:channel_user))
    _shopkeeper = Shopkeeper.find_by(user_id: channel_params[:shopkeeper_user_id])

    if _shopkeeper.present?
      raise Errors::InvalidParameterError.new("无效的店主用户ID")
    else
      _attrs = params[:channel_user].slice(
        :name, :phone, :password
      ) || {}
      _attrs.reverse_merge!(
        name: _shopkeeper.user_name,
        phone: _shopkeeper.user_phone,
      )

      @channel.build_channel_user(_attrs)
      @channel.shop_id = _shopkeeper.shop_id
    end

    if @channel.save
      render :show
    else
      raise ActiveRecord::RecordInvalid.new(@channel)
    end
  end

  def update
    @channel = ::Channel.find(params[:id])
    if params[:channel_user].present?
      @channel.channel_user.password = params[:channel_user][:password]
    end

    if @channel.update(channel_params.except(:channel_user))
      render :show
    else
      raise ActiveRecord::RecordInvalid.new(@channel)
    end
  end

  private
  def channel_params
    params.require(:channel).permit(
      :name, :category, :source, :status,
      :shopkeeper_user_id, channel_user: [
        :name, :phone, :password
      ]
    )
  end
end