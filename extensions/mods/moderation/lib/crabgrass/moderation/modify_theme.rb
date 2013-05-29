module Crabgrass::Moderation
  module ModifyTheme
    extend ActiveSupport::Concern

    included do
      before_filter :moderation_navigation
    end

    protected

    def moderation_navigation
      current_theme.define_navigation do
        global_section :admin do
          label   { :admin.t }
          visible { may_admin_site? }
          url     '/admin/users'
          active  { controller.class.name.include?('Admin') }

          context_section :moderation do
            label   { "Moderator" }
            active  { controller?('admin/pages', 'admin/posts') }
            url     '/admin/pages'
            visible { true || may_moderate? }

            local_section :pages do
              label { "Moderate Pages" }
              url   { admin_pages_path }
              active { controller?('admin/pages') }
              visible { true || may_moderate? }
              icon :mime_default
            end

            local_section :posts do
              label { "Moderate Comments" }
              url   { admin_posts_path }
              active { controller?('admin/posts') }
              visible { true || may_super? }
              icon :comment
            end

          end
        end
      end

    end
  end
end
