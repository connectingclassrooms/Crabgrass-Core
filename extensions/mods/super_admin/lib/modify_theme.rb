module ModifyTheme
  extend ActiveSupport::Concern

  included do
    before_filter :modify_theme
  end

  protected

  def modify_theme
    current_theme.define_navigation do
      global_section :admin do
        label   { :admin.t }
        visible { may_admin_site? }
        url     '/admin'
        active  { controller.class.name.include?('Admin') }

        context_section :super_admin do
          label { :super_admin.t }
          active { controller?('admin/groups', 'admin/users') }
          visible { true || may_super? }

          local_section :new_user do
            label { "Create New User" }
            url   { new_admin_user_path }
            active { controller?('admin/users') && action?(:new) }
            visible { true || may_super? }
            icon :user_add
          end

          local_section :users do
            label { "Edit Users" }
            url   { admin_users_path }
            active { controller?('admin/users') && action?(:index) }
            visible { true || may_super? }
            icon :user
          end

          local_section :new_group do
            label { "Create New Group" }
            url   { new_admin_group_path }
            active { controller?('admin/groups') && action?(:new) }
            visible { true || may_super? }
            icon :membership_add
          end

          local_section :groups do
            label { "Edit Groups" }
            url   { admin_groups_path }
            active { controller?('admin/groups') && action?(:index) }
            visible { true || may_super? }
            icon :group_contributions
          end
        end

      end
    end

  end
end
