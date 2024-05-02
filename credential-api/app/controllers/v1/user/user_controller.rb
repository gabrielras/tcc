# frozen_string_literal: true

class V1::User::UserController < V1::V1Controller
  before_action :current_user

  def current_user
    begin
      token = request.headers['Authorization'].split(' ').last
      jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256').first
      @current_user = User.find_by_id!(jwt_payload['user_id'])
      @current_user
    rescue
      head :unauthorized
    end
  end
end
