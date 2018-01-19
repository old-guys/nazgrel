class Api::Web::UsersController < Api::Web::BaseController
  before_action :set_user, only: [:show, :update, :destroy]
  include ActionSearchable

  # GET /api/web/users
  # GET /api/web/users.json
  def index
    @users = User.preload(:roles).all

    @users = filter_by_pagination(relation: @users)
  end

  # GET /api/web/users/1
  # GET /api/web/users/1.json
  def show
  end

  # POST /api/web/users
  # POST /api/web/users.json
  def create
    @user = User.new(user_params)

    if @user.save
      render :show
    else
      raise ActiveRecord::RecordInvalid.new(@user)
    end
  end

  # PATCH/PUT /api/web/users/1
  # PATCH/PUT /api/web/users/1.json
  def update
    if @user.update(user_params)
      render :show
    else
      raise ActiveRecord::RecordInvalid.new(@user)
    end
  end

  # # DELETE /api/web/users/1
  # # DELETE /api/web/users/1.json
  # def destroy
  #   @user.destroy
  #
  #   render :show
  # end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.fetch(:user).permit(
      :email, :phone, :password,
      :role_type,
      role_ids: []
    )
  end
end