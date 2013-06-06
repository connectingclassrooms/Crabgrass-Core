module Crabgrass::Moderation
  module PostActions
    extend ActiveSupport::Concern

    included do
      alias_method_chain :edit_post_link, :moderation
    end

    def edit_post_link_with_moderation(post)
      (flag_post_link(post) || "".html_safe) +
        edit_post_link_without_moderation(post)
    end

    def flag_post_link(post)
      return unless logged_in?
      return if post.user == current_user
      content_tag :div, link_to_flag_post(post),
        :class => 'post_action_icon',
        :style => 'margin-right:22px; display: block'
    end

    def link_to_flag_post(post)
      if flag = post.moderated_flags.where(user_id: current_user).first
        link_to_remote_icon 'sad_minus',
          url: post_moderated_flag_path(post, flag),
          method: :delete
      else
        url = new_post_moderated_flag_path(post)
        link_to_modal '',
          { url: url, icon: 'sad_plus', title: :flag_inappropriate.t },
          { :class => 'small_icon_button' }
      end
    end

  end
end
