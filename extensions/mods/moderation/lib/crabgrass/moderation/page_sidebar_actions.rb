module Crabgrass::Moderation
  module PageSidebarActions
    extend ActiveSupport::Concern

    included do
      alias_method_chain :participate_commands, :moderation
    end

    def participate_commands_with_moderation
      participate_commands_without_moderation.tap do |group|
        group.commands << flag_page
      end
    end

    def flag_page
      return if @page.created_by == current_user
      if flag = @page.moderated_flags.where(user_id: current_user).first
        Struct::SidebarCommand.new unflag_link(flag), 'flag_li'
      else
        flag_command
      end
    end

    def flag_command
      popup_command name: 'yucky',
        label: I18n.t(:flag_inappropriate),
        icon: 'sad_plus',
        id: 'flag_li',
        url: new_page_flag_path(@page)
    end

    def unflag_link
      link_to I18n.t(:flag_appropriate),
        page_flag_path(@page, flag),
        method: :destroy,
        icon: 'sad_minus'
    end

  end
end
