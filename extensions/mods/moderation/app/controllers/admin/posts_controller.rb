class Admin::PostsController < Admin::BaseController
  include ModerationFinders

  permissions 'admin/moderation'
  helper 'moderation'

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
  # for deleting:      params[:post]['deleted_at']  == Time.now
  # for undeleting:    params[:post]['deleted_at']  == nil
  def update
    @posts = Post.find(params[:id])
    post_attrs = params[:post].symbolize_keys.slice :vetted, :deleted_at
    @posts.update_attributes(post_attrs)
    redirect_to :action => 'index', :view => params[:view]
  end

  protected

  def fetch_posts(view)
    options = moderation_options.merge :page => params[:page]
    @flagged = Post.paginate_by_path(path_for_view, options)
    @admin_active_tab = 'page_post_moderation'
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

  def path_for_view
    VIEW_PATH[params[:view]]
  end

  VIEW_PATH = {
    'all'              => "/descending/updated_at",
    'new'              => "/descending/created_at/moderation/new",
    'vetted'           => "/descending/created_at/moderation/vetted",
    'deleted'          => "/descending/created_at/moderation/deleted"
  }

end

