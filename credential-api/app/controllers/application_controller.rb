class ApplicationController < ActionController::API
  include Pundit::Authorization
  include Pagy::Backend

  before_action :authenticate_user!, :current_user

  def authenticate_user!
    begin
      token = request.headers['Authorization']&.split&.last
      jwt_payload = JwtModule.authenticate_token(token)
      @current_user = User.find(jwt_payload["user_id"])
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
      head :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
