class ModeratedFlagsController < ApplicationController
  include ModerationNotice

  helper 'moderation'

  permissions 'admin/moderation'
  permissions 'flag'
  permissions 'pages'
  helper 'pages/sidebar'
  layout nil

  guard new: :may_add_yucky?,
    create: :may_add_yucky?,
    destroy: :may_remove_yucky?

  before_filter :login_required

  def new
  end

  def create
    if params[:flag]
      @flag.update_attributes params[:flag]
      send_moderation_notice(@flagged)
    end
    close_popup
  end

  def destroy
    ### for some reason we update the :yucky_count in the page/post/chat model
    @flag.destroy
    @flagged.update_attribute(:yuck_count, @flagged.moderated_flags.count)
    close_popup
  end

  def close_popup
    if @post
      render :template => '/posts/reset_post'
    elsif @page
      render :template => 'pages/sidebar/reset'
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

