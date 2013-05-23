class Admin::UsersController < Admin::BaseController

  before_filter :fetch_user_by_login, :only => [ :show, :edit, :update, :destroy ]

  # GET /users
  def index
    @letter = (params[:letter] || '')
    @users = users_to_show.alphabetized(@letter).paginate(pagination_params)
    @pagination_letters = users_to_show.logins_only.map{|u| u.initial}.uniq
    @show = params[:show]
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(params[:user])
    @user.save!

    # save avatar
    avatar = Avatar.create(params[:image])
    @user.avatar = avatar

    @user.save!
    flash[:notice] = 'User was successfully created.'
    redirect_to(:action => :show, :id => @user.to_param)
  rescue Exception => exc
    error @user
    render :action => 'new', :status => :unprocessable_entity
  end

  # PUT /users/1
  def update

    save_or_update_avatar if params[:image]

    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to(:action => :show, :id => @user)
    else
      error @user
      # we need to reset the login so the form still works on the
      # same user.
      @user.login = @user.login_was if @user.login_changed?
      render :action => "edit", :status => :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy

    redirect_to(admin_users_path)
  end

  private
  def fetch_user_by_login
    @user = User.find_by_login(params[:id])
  end

  def save_or_update_avatar
    if @user.avatar
      for size in %w(xsmall small medium large xlarge)
        expire_page :controller => 'static', :action => 'avatar', :id => @user.avatar.id, :size => size
      end
      @user.avatar.image_file = params[:image][:image_file]
      @user.avatar.save!
    else
      avatar = Avatar.create(params[:image])
      @user.avatar = avatar
    end
  end

  protected

  def users_to_show
    case params[:show]
    when 'active'
      User.active_since(1.month.ago)
    when 'inactive'
      User.inactive_since(1.month.ago)
    else
      User
    end
  end

end
