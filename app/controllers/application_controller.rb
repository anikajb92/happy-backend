class ApplicationController < ActionController::API

  def auth
    auth_header = request.headers[:Authorization]

    if !auth_header
      render json: {error: 'Token must be present'}
    else 
      token = auth_header.split(' ')[1]
      secret = 'mumbojumbo'
      begin
        JWT.decode token, secret
      rescue 
        render json: {error: 'Bad token'}, status: :forbidden
      end
    end
  end
end
