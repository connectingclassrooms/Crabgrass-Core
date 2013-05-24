=begin
this will create the routes
  /admin/pages -> Admin::PagesController
  /admin/wall_posts  -> Admin::WallPostsController
  /admin/discussion_posts  -> Admin::DiscussionPostsController
=end

Crabgrass.mod_routes do |map|
  map.namespace :admin do |admin|
    admin.resources :pages
    admin.resources :wall_posts
    admin.resources :discussion_posts
  end
end
