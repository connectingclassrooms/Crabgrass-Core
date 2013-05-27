class Admin::PostsController < Admin::BaseController
  verify :method => :post, :only => [:update]

  permissions 'admin/moderation'

  def index
    params[:view] ||= 'new'
    view = params[:view]
    @current_view = view
    if view == 'all'
      @flagged = Post.paginate({ :order => 'updated_at DESC', :page => params[:page]})
    else
      # defined by subclasses
      fetch_posts(view)
    end
  end

  # for vetting:       params[:post][:vetted] == true
  # for deleting:      params[:post]['flow']  == FLOW[:deleted]
  # for undeleting:    params[:post]['flow']  == nil
  def update
    @posts = Post.find(params[:id])
    post_attrs = params[:post].symbolize_keys.slice :vetted, :flow
    @posts.update_attributes(post_attrs)
    redirect_to :action => 'index', :view => params[:view]
  end

  def set_active_tab
    @active_tab = :moderation
  end

  def authorized?
    if action?(:index)
      may_see_moderation_panel?
    else
      may_moderate?
    end
  end

  private
  prepend_before_filter :fetch_flagged
  def fetch_flagged
    return unless params[:id]
    @post = Post.find params[:id]
    @flag = @post.moderated_flags.first
  end


end

