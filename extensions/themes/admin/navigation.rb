define_navigation(parent: 'default') do

  global_section :admin do
    label   { :admin.t }
    visible { may_admin_site? }
    url     '/admin'
    active  { controller?('admin/groups', 'admin/users') }
  end
end

