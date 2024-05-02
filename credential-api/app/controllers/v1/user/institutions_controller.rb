class V1::User::InstitutionsController < V1::User::UserController
  def index
    render json: @current_user.institutions, status: :ok
  rescue => exception
    render json: { error: { message: exception.message } }, status: :unprocessable_entity
  end

  def create
    result = ::Institutions::Create.result(
      attributes: institution_params, user: @current_user
    )

    if result.success?
      render json: result.institution, status: :created
    else
      render json: { error: { message: result.error } }, status: :unprocessable_entity
    end
  rescue => exception
    render json: { error: { message: exception.message } }, status: :unprocessable_entity
  end

  private

  def institution_params
    params.require(:institution).permit(:title).to_h
  end
end
