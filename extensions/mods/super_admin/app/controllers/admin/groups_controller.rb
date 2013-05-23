class Admin::GroupsController < Admin::BaseController

  before_filter :fetch_group_by_name, :only => [ :show, :edit, :update, :destroy ]

  # GET /groups
  def index
    @letter = (params[:letter] || '')
    @groups = Group.alphabetized(@letter).find(:all)
  end

  # GET /groups/1
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  def create
    @group = Group.new(params[:group])

    # save avatar
    avatar = Avatar.create(params[:image])
    @group.avatar = avatar

    if @group.save
      flash[:notice] = 'Group was successfully created.'
      redirect_to(@group)
    else
      error @group
      render :action => "new"
    end
  end

  # PUT /groups/1
  def update

    save_or_update_avatar if params[:image_file]

    if @group.update_attributes(params[:group])
      flash[:notice] = 'Group was successfully updated.'
      redirect_to(@group)
    else
      error @group
      # we need to reset the login so the form still works on the
      # same user.
      @group.name = @group.name_was if @group.name_changed?
      render :action => "edit"
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy_by(current_user)

    redirect_to(groups_path)
  end

  private
  def fetch_group_by_name
    @group = Group.find_by_name(params[:id])
  end

  def save_or_update_avatar
    if @group.avatar
      for size in %w(xsmall small medium large xlarge)
        expire_page :controller => 'static', :action => 'avatar', :id => @group.avatar.id, :size => size
      end
      @group.avatar.image_file = params[:image_file]
      @group.avatar.save!
    else
      avatar = Avatar.create(:image_file => params[:image_file])
      @group.avatar = avatar
    end
  end

end
