class Admin::FlagsController < Pages::SidebarsController
  include ModerationNotice

  helper 'base_page'

  permissions 'admin/moderation'
  permissions 'flag'

  before_filter :login_required

  def new
    new_params = @post ? { post_id: @post.id } : { page_id: @page.id }
    form_url = admin_flags_url(new_params.merge(method: :post))
    render 'base_page/yucky/show_add_popup', form_url: form_url
  end

  def create
    if params[:flag]
      @flag.add({:reason=>params[:reason],:comment=>params[:comment]}) unless @flag.nil?
      send_moderation_notice(@flagged)
    end
    close_popup
  end

  def destroy
    ### for some reason we update the :yucky_count in the page/post/chat model
    @flag.destroy
    @flagged.update_attribute(:yuck_count, @flagged.moderated_flags.count)
    if @post
      render :update do |page|
        page.replace_html "post-body-#{@post.id}",
          partial: 'posts/post_body',
          locals: {post: @post}
      end
    elsif @page
      redirect_to referer
    end
  end

  def close_popup
    if @post
      render :template => '/posts/reset_post'
    elsif @page
      render :template => 'base_page/reset_sidebar'
    end
  end

  protected

  prepend_before_filter :fetch_flag
  def fetch_flag
    @post = Post.find(params[:post_id]) if params[:post_id]
    @page = Page.find(params[:page_id]) if params[:page_id]
    @flagged = @post || @page
    return false unless @flagged
    @flag = @flagged.moderated_flags.find_by_user_id(current_user.id)
    @flag ||= ModeratedFlag.new(:flagged => @flagged, :user => current_user)
  end

end

