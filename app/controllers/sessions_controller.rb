class SessionsController < ApplicationController

  protect_from_forgery :except => [:createapi]

  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      sign_in user
      redirect_back_or user
    end
  end

  def createapi
    respond_to do |format|
      #format.xml  { render :xml => @user.feed }
      format.xml do
        render :inline => "xml.p {'Horrid coding practice!'}", :type => :builder
      end
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
