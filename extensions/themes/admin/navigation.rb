define_navigation(parent: 'default') do

  global_section :admin do
    label   { :admin.t }
    visible { may_admin_site? }
    url     '/admin'
    active  { controller?('admin/groups', 'admin/users') }
    html    :partial => '/layouts/global/nav/admin_menu'

    context_section :groups do
      label { :groups.t }
      url   { admin_groups_path }
      active { controller?('admin/groups') }
      visible { true || may_super? }
    end

    context_section :users do
      label { :users.t }
      url   { admin_users_path }
      active { controller?('admin/users') }
      visible { true || may_super? }
    end

  end
end

