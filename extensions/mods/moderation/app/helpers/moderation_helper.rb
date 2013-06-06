module ModerationHelper

  def new_flag_form(&block)
    form_remote_for [@flagged, @flag],
      loading: show_spinner('popup'),
      html: {id: 'yucky_page_form'},
      &block
  end

  def tab_link(title, view=nil, options={})
    view ||= title
    obj_type = options[:obj_type] || 'pages'
    controller_path = 'admin/pages' if obj_type == 'pages'
    controller_path = 'admin/posts' if obj_type == 'posts'
    link_to_active( title, :controller => controller_path, :action => 'index', :view => view)
  end

  def actions_for_view
    VIEW_ACTIONS[@current_view]
  end

  VIEW_ACTIONS = {
    new:              ['approve', 'trash'],
    vetted:           ['trash'],
    deleted:          ['undelete'],
    public:           ['remove_public'],
    public_requested: ['approve_public', 'reject_public']
  }.with_indifferent_access

  def button_to_action(obj, action)
    button_to action.to_s.capitalize,
      update_url(obj, action),
      method: :put
  end

  def update_url(obj, action)
    # turn DiscussionPage into Page etc. :
    obj = obj.becomes(obj.class.base_class)
    url_for([:admin, obj]) + '?' + update_params(obj, action).to_query
  end

  def update_params(obj, action)
    { :view => @current_view,
      obj.class.name.downcase => UPDATE_PARAMS[action]
    }
  end

  UPDATE_PARAMS = {
    remove_public:  { public: false },
    reject_public:  { public: false },
    approve_public: { public: true },
    trash:          { flow:   FLOW[:deleted] },
    approve:        { vetted: true },
    undelete:       { flow:   nil }
  }.with_indifferent_access

  def flags_for_details(flagged_id, type)
    ModeratedFlag.find_all_by_type_and_flagged_id(type, flagged_id)
  end

  def link_to_see_all_flags_by_type(obj_type)
    if obj_type == "pages"
      icon = 'page_white_copy_16'
      title = 'See All Pages'
      controller = 'pages'
    elsif obj_type == "posts"
      icon = 'page_discussion_16'
      title = 'See All Posts'
      controller = 'posts'
    end
    link = "<span class='icon #{icon}'>" + link_to_active( h(title), { :controller => "admin/#{controller}", :action => 'index', :view => 'all' }, @current_view == 'all' ) + "</span>"
    link.html_safe
  end

  def display_public_pages_links(obj_type)
    return unless obj_type == 'pages'
    render :partial => '/admin/pages/public_links'
  end

  def listing_custom_column_header(obj_type, view)
    return "Type" if obj_type == 'pages'
    return "Comment" if obj_type == 'posts'
  end

  def listing_custom_column_content(flagged_obj, view)
    if flagged_obj.is_a?(Post)
      h(post_link(flagged_obj))
    elsif flagged_obj.is_a?(Page)
      h(flagged_obj.type)
    else
      "n/a"
    end
  end

  def flagged_page_link(flagged_obj)
    if flagged_obj.is_a?(Page)
       link_to flagged_obj.title, page_url(flagged_obj), {:target =>  '_blank'}
    elsif flagged_obj.is_a?(Post)
       page_link(flagged_obj)
    else
      "n/a"
    end
  end

  def list_created_by(flagged_obj)
    h(flagged_obj.created_by.try.login) || "Unknown"
  end

  def show_flag_details(flag)
    flag_type = flag.class.to_s
    return unless flag_type =~ /^Moderated/
    render :partial => '/admin/show_details', :locals => {:flagged_id => flag.flagged_id, :obj_type => flag_type }
  end

end
