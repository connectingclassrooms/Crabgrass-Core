self.override_views = false
self.load_once = false

Rails.application.config.to_prepare do
  #require 'super_admin_listener'

  require File.expand_path('routes', File.dirname(__FILE__))

  extend_model :User do
    include Crabgrass::SuperAdmin::Extends::User
  end

  Common::Application::BeforeFilters.module_eval do
    include Crabgrass::SuperAdmin::ModifyTheme
  end

end
