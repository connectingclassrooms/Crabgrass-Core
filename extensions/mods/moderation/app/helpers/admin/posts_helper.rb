module Admin::PostsHelper

  def post_link(post)
    if post.discussion.page
      link_to_if(post.deleted_at.nil?, post.body[0..60] + '...', "#{page_url(post.discussion.page)}#posts-#{post.id}")
    elsif post.discussion.commentable
      link_to_if(post.deleted_at.nil?, post.body[0..60] + '...', user_url(post.discussion.commentable))
    end
  end

  def page_link(post)
    if post.discussion.page
      link_to(post.discussion.page.title, page_url(post.discussion.page))
    elsif post.discussion.commentable
      link_to(post.discussion.commentable.display_name, user_url(post.discussion.commentable))
    end
  end

end


