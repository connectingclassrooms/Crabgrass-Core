class Admin::PagesController < Admin::BaseController
  include ModerationFinders

  permissions 'admin/moderation'
  helper 'moderation'

  def index
    params[:view] ||= 'new'
    view = params[:view]
    @current_view = view

    if params[:group] && params[:group].any?
      @group = Group.find(params[:group])
    end

    options = moderation_options.merge :page => params[:page]
    options.merge!({:flow => :deleted}) if view == 'deleted'
    @flagged = Page.paginate_by_path(path_for_view, options)
  end

  #     vetting:       params[:page]['vetted'] == true
  #     deleting:      params[:page]['flow']   == FLOW[:deleted]
  #     undeleting:    params[:page]['flow']   == nil
  #     making public: params[:page]['public'] == true
  # making non public: params[:page]['public'] == true
  def update
    page_attrs = params[:page].with_indifferent_access
    page_attrs.slice! :vetted, :flow, :public
    @page.update_attributes(page_attrs)
    redirect_to :action => 'index', :view => params[:view]
  end

  protected

  def set_active_tab
    @active_tab = :moderation
    @admin_active_tab = 'page_moderation'
  end

  def path_for_view
    VIEW_PATH[params[:view]]
  end

  VIEW_PATH = {
    'all'              => "/descending/updated_at",
    'public requested' => "/descending/created_at/public_requested/",
    'public'           => "/descending/created_at/public/",
    'new'              => "/descending/created_at/moderation/new",
    'vetted'           => "/descending/created_at/moderation/vetted",
    'deleted'          => "/descending/created_at/moderation/deleted"
  }

  def authorized?
    if action?(:index)
      may_see_moderation_panel?
    else
      may_moderate?
    end
  end

  prepend_before_filter :fetch_page, only: :update

  def fetch_page
    @page = Page.find params[:id]
    raise_not_found(:page.t) unless @page
  end

end

