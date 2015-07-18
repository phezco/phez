class Oauth::ApplicationsController < Doorkeeper::ApplicationsController
  before_filter :authenticate_user!

  def index
    @applications = current_user.oauth_applications
  end

  def show
    @application = current_user.oauth_applications.find(params[:id])
  end

  def edit
    @application = current_user.oauth_applications.find(params[:id])
  end

  def update
    @application = Doorkeeper::Application.find(params[:id])
    if @application.update(application_params)
      flash[:notice] = 'Application updated.'
      redirect_to oauth_application_url(@application)
    else
      render :edit
    end
  end

  def create
    @application = Doorkeeper::Application.new(application_params)
    @application.owner = current_user
    if @application.save
      flash[:notice] = I18n.t(:notice, :scope => [:doorkeeper, :flash, :applications, :create])
      redirect_to oauth_application_url(@application)
    else
      render :new
    end
  end

end