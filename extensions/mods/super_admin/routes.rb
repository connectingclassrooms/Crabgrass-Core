=begin
this will create the routes
  /admin/groups -> Admin::GroupsController
  /admin/users  -> Admin::UsersController
=end

Crabgrass.mod_routes do |map|
  map.namespace :admin do |admin|
    admin.resources :groups
    admin.resources :users
    admin.resources :memberships
  end
end
