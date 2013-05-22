self.override_views = false
self.load_once = false

Rails.application.config.to_prepare do
  #require 'super_admin_listener'
end

require File.expand_path('routes', File.dirname(__FILE__))

extend_model :User do
  include Crabgrass::SuperAdmin::Extends::User
end

extend_model 'ApplicationController' do
  include Crabgrass::SuperAdmin::ModifyTheme
end

