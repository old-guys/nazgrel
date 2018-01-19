class Api::Web::PermissionsController < Api::Web::BaseController
  before_action :set_permission, only: [:show, :update, :destroy]
  include ActionSearchable

  # GET /api/web/permissions
  # GET /api/web/permissions.json
  def index
    @permissions = Permission.all

    @permissions = filter_by_pagination(relation: @permissions)
  end

  # GET /api/web/permissions/1
  # GET /api/web/permissions/1.json
  def show
  end

  # POST /api/web/permissions
  # POST /api/web/permissions.json
  def create
    @permission = Permission.new(permission_params)

    if @permission.save
      render :show
    else
      raise ActiveRecord::RecordInvalid.new(@permission)
    end
  end

  # PATCH/PUT /api/web/permissions/1
  # PATCH/PUT /api/web/permissions/1.json
  def update
    if @permission.update(permission_params)
      render :show
    else
      raise ActiveRecord::RecordInvalid.new(@permission)
    end
  end

  # DELETE /api/web/permissions/1
  # DELETE /api/web/permissions/1.json
  def destroy
    @permission.destroy

    render :show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_permission
      @permission = Permission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def permission_params
      params.fetch(:permission).permit(
        :name, :subject, :uid
      )
    end
end