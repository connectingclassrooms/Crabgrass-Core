=begin
this will create the routes
  /admin/pages -> Admin::PagesController
  /admin/wall_posts  -> Admin::WallPostsController
  /admin/discussion_posts  -> Admin::DiscussionPostsController
=end

Crabgrass.mod_routes do |map|
  map.namespace :admin do |admin|

    admin.resources :posts do |posts|
      posts.resources :flags
    end

    admin.resources :pages do |pages|
      pages.resources :flags
      pages.resources :publications
    end
  end

  map.resources :pages, :only => [] do |pages|
    pages.resources :flags
    pages.resources :publications
  end

end
