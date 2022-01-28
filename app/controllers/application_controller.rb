class ApplicationController < ActionController::API
  include ExceptionHandler

  def payload
    auth_header = request.headers['Authorization'];
    token = auth_header.split(' ').last
    AuthenticationTokenService.decode(token)[0]
  rescue StandardError
    nil
  end

  def current_user!
    @current_user = User.find_by(id: payload['user_id'])
  end

  def invalid_authentication
    render json: { error: 'You will need to login first' }, status: :unauthorized
  end

  def authenticate_request!
    return invalid_authentication if !payload || !AuthenticationTokenService.valid_payload(payload.first)

    current_user!
    invalid_authentication unless @current_user
  end
end
