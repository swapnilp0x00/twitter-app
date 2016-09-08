class UsersController < ApplicationController

  before_action :logged_in_user, only: [:edit, :update,:index]
  before_action :correct_user,   only: [:edit, :update]


  def index
      @users = User.paginate(page: params[:page],:per_page => 10)
  end


  def correct_user
     @user = User.find(params[:id])
     redirect_to(root_url) unless current_user?(@user)
  end

  def logged_in_user
      unless logged_in?      #checking only whether user logged in or not is not enough,
                              #this only fix access to non logged users to edit and update
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
  end

  def new
    @user=User.new
  end

  def show
    @user=User.find(params[:id])
  end

  def create
    @user=User.new(user_params)
    if @user.save
      # Handle a successful save.
      log_in @user
      flash[:success] = "Welcome to the Sample App!"        #setting flash for success message
      redirect_to @user
    else
      render 'new'
      #redirect_to signup_path
    end
  end

  def edit
    @user=User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end


  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

end
