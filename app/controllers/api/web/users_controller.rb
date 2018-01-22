class Api::Web::UsersController < Api::Web::BaseController
  before_action :set_user, only: [:show, :update, :access_status, :destroy]
  include ActionSearchable

  # GET /api/web/users
  # GET /api/web/users.json
  def index
    @users = User.preload(:roles).all

    @users = filter_records_by(relation: @users)
    @users = simple_search(relation: @users)
    @users = sort_records(relation: @users)
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

  def access_status
    _opert_name = "#{user_access_status_params[:access_status]}_access!"

    if _opert_name.eql?("lock_access!")
      @user.lock_access!(send_instructions: false)
    end
    if _opert_name.eql?("unlock_access!")
      @user.unlock_access!
    end

    render :show
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

  def user_access_status_params
    params.fetch(:user).permit(
      :access_status
    )
  end
end