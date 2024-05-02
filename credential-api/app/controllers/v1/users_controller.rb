# frozen_string_literal: true

class V1::UsersController < V1::V1Controller
  def log_in
    result = V1::Users::LogIn.result(email: params[:email], password: params[:password])
    if result.success?
      render json: { message: I18n.t('controllers.v1.sessions.log_in.success'), data: { user: result.user, token: result.token } }, status: :ok
    else 
      render json: { message: result.error }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { message: I18n.t('controllers.v1.sessions.log_in.failure') }, status: :unprocessable_entity
  end

  def sign_up
    result = V1::Users::SignUp.result(attributes: { first_name: params[:first_name], last_name: params[:last_name], email: params[:email], password: params[:password] }.to_h)
    if result.success?
      render json: { message: I18n.t('controllers.v1.sessions.sign_up.success'), data: { user: result.user, token: result.token } }, status: :ok
    else 
      render json: { message: result.error }, status: :unprocessable_entity
    end
  rescue StandardError => e
    byebug
    render json: { message: I18n.t('controllers.v1.sessions.sign_up.failure') }, status: :unprocessable_entity
  end
end
