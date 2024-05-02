class V1::CredentialsController < V1::V1Controller
  before_action :set_institution

  def index
    @q = @institution.credentials.ransack(params[:q])
    @pagy, @credentials = pagy(@q.result)
    render json: @credentials
  rescue => exception
    render json: { error: { message: exception.message } }, status: :unprocessable_entity
  end

  private

  def set_institution
    @institution = policy_scope(Institution).find(params[:id])
  end
end
