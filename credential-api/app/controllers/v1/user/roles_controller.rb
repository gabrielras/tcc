class V1::User::RolesController < V1::User::UserController
  before_action :set_institution
  before_action :set_role, only: [:update]

  def index
    @q = @institution.roles.ransack(params[:q])
    @pagy, @roles = pagy(@q.result)
    render json: @roles
  rescue => exception
    render json: { error: { message: exception.message } }, status: :unprocessable_entity
  end

  def create
    result = ::Roles::Create.result(current_user: current_user, attributes: role_params)
    
    render json: result.role, status: :created
  rescue => exception
    render json: { error: { message: exception.message } }, status: :unprocessable_entity
  end

  private

  def role_params
    params.require(:role).permit(:email).to_h
  end

  def set_role
    @role = policy_scope(Role).find(:id)
  end

  def set_institution
    @institution = policy_scope(Institution).find(:institution_id)
  end
end
