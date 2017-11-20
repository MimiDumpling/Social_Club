class UsersController < ApplicationController
  def new
    @user = User.new
  end


  def create
    @user = User.new(user_params)
 
    if @user.save
      session[:user_id] = @user.id
      redirect_to plans_index_path, notice: 'Thank you for signing up!'
    else
      redirect_to registration_index_path(@user, :error => @user.errors.full_messages.first)
    end
  end


  def login
    @user = User.find_by_email(params[:email])
    if @user.password == params[:password]
      give_token
    else
      redirect_to registration_index_path
    end
  end


  private
    def user_params
      params.require(:user).permit(:email, :password)
    end 
end
