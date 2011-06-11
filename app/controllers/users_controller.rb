class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :index, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  before_filter :already_logged_in, :only => [:new, :create]
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def new
    @title = "Sign up"
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end
  
  def edit
    @title = "Edit user"
  end
  
  def update
     if @user.update_attributes(params[:user])
       flash[:success] = "Profile updated."
       redirect_to @user
     else
       @title = "Edit user"
       render 'edit'
     end
  end
   
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def destroy
    user_to_destroy = User.find(params[:id])
    if current_user?(user_to_destroy)
      flash[:error] = "Sorry.  You can't delete yourself."
      redirect_to users_path
    else
      user_to_destroy.destroy
      flash[:success] = "User destroyed."
      redirect_to users_path  
    end
  end
    

   private
     
     def correct_user
       @user = User.find(params[:id])
       redirect_to(root_path) unless current_user?(@user)
     end
     
     def admin_user
       redirect_to(root_path) unless current_user.admin?
     end
     
     def already_logged_in
       redirect_to(root_path) if signed_in?
     end

end
