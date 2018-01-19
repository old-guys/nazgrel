class Api::Web::RolesController < Api::Web::BaseController
  before_action :set_role, only: [:show, :update, :destroy]
  include ActionSearchable

  # GET /api/web/roles
  # GET /api/web/roles.json
  def index
    @roles = Role.preload(:permissions).all

    @roles = filter_by_pagination(relation: @roles)
  end

  # GET /api/web/roles/1
  # GET /api/web/roles/1.json
  def show
  end

  # POST /api/web/roles
  # POST /api/web/roles.json
  def create
    @role = Role.new(role_params)

    if @role.save
      render :show
    else
      raise ActiveRecord::RecordInvalid.new(@role)
    end
  end

  # PATCH/PUT /api/web/roles/1
  # PATCH/PUT /api/web/roles/1.json
  def update
    if @role.update(role_params)
      render :show
    else
      raise ActiveRecord::RecordInvalid.new(@role)
    end
  end

  # DELETE /api/web/roles/1
  # DELETE /api/web/roles/1.json
  def destroy
    @role.destroy

    render :show
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = Role.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def role_params
    params.fetch(:role, {}).permit(
      :name, permission_ids: []
    )
  end
end