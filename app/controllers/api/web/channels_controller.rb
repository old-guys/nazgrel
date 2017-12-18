class Api::Web::ChannelsController < Api::Web::BaseController
  include ActionSearchable

  #
  # filters: [{
  #   name: "status", field_type: "integer",
  #   operator: "eq", query: "0"
  # }],
  # order: "id desc",
  # query: "徐"
  def index
    @channels = ::Channel.preload(
      :channel_users, :own_shop, :own_shopkeeper
    ).order(id: :desc)

    @channels = filter_records_by(relation: @channels)
    @channels = simple_search(relation: @channels)
    @channels = sort_records(relation: @channels)
    @channels = filter_by_pagination(relation: @channels)
  end

  def show
    @channel = ::Channel.find(params[:id])
  end

  def create
    @channel = ::Channel.new(channel_params.except(:channel_user))
    _shopkeeper = Shopkeeper.find_by(user_id: channel_params[:shopkeeper_user_id])

    if _shopkeeper.blank?
      raise Errors::InvalidParameterError.new("无效的店主用户ID")
    end

    if ChannelUser.where(shopkeeper_user_id: _shopkeeper.user_id).exists?
      raise Errors::InvalidParameterError.new("该店主已经绑定了渠道")
    end

    _attrs = channel_params[:channel_user].slice(
      :name, :phone, :password
    ) || {}
    _attrs.reverse_merge!(
      name: _shopkeeper.user_name,
      phone: _shopkeeper.user_phone,
      role_type: :manager,
      shop_id: _shopkeeper.shop_id,
      shopkeeper_user_id: _shopkeeper.user_id
    )

    @channel.channel_users.new(_attrs)
    @channel.shop_id = _shopkeeper.shop_id
    @channel.shopkeeper_user_id = _shopkeeper.user_id

    if @channel.save
      render :show
    else
      raise ActiveRecord::RecordInvalid.new(@channel)
    end
  end

  def update
    @channel = ::Channel.find(params[:id])
    _channel_user = @channel.channel_users.manager.first
    _password = channel_params[:channel_user][:password] rescue nil

    if _channel_user
      _channel_user.update(password: _password) if _password.present?
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
      :name, :category, :city, :source, :status,
      :shopkeeper_user_id, channel_user: [
        :name, :role_type, :phone, :password
      ]
    )
  end
end