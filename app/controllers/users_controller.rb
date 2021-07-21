class UsersController < ApplicationController

  def index
    @users = User.all 
    render json: @users, status: :ok
  end 

  def create # Allows new user to create an account
    @user = User.create user_params
    render json: @user, status: :created
  end 

  def login # Allows existing user to login
    @user = User.find_by username: params[:user][:username]

    if !@user
      render json: {error: 'Invalid username or password.'}, status: :unauthorized
    else

      if !@user.authenticate params[:user][:password] #authenticate is a bcrypt method that checks the hashed password
        render json: {error: 'Invalid username or password.'}, status: :unauthorized #same message for extra security
      else 

        payload = {user_id: @user.id} # anytime a jwt is sent, we'll know who it is
        secret = 'mumbojumbo'
        @token = JWT.encode payload, secret

        render json: {token: @token, username: @user.username}, status: :ok
      end 
      
    end
  end 

  private # PRIVATEEEEEE 

  def user_params
    params.require(:user).permit(:username, :password)
  end 
end
