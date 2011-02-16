class UsersController < ApplicationController

  protect_from_forgery :except => [:feedapi]
  respond_to :html, :xml  

  before_filter :authenticate, :except => [:show, :new, :create, :feedapi]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  before_filter :basic_authenticate, :only => [ :feedapi ]


  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
    respond_with(@users)
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user      
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # Handle a successful save.
    else
      @title = "Sign up"
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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  def feedapi
    #@title = "Feed"
    #@user = User.authenticate(email, pwd);
    #@feed = @user.feed.paginate(:page => params[:page])
    respond_to do |format|
          #format.html { render 'show_feed' }
          format.xml  { render :xml => @user.feed }
          #format.xml do
          #  render :inline => "#{params} #{request.headers["HTTP_AUTHORIZATION"]}\n"
          #end
          #format.json { render :json => @user.feed }
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

    USER_NAME, PASSWORD = "eric", "pwd"

    #code from
    #http://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Basic.html#method-i-authentication_request
    def basic_authenticate
      authenticate_or_request_with_http_basic do |user_name, password|
        #user_name == USER_NAME && password == PASSWORD
        @user = User.authenticate(user_name, password)
        return true
      end
    end


end
