self.override_views = false
self.load_once = false

Rails.application.config.to_prepare do
  #require 'super_admin_listener'
end

apply_mixin_to_model(Site, SiteExtension)
apply_mixin_to_model(Request, RequestExtension)
apply_mixin_to_model(RequestToJoinUs, RequestToJoinUsExtension)

require File.expand_path('routes', File.dirname(__FILE__))
require File.expand_path('lib/modify_theme', File.dirname(__FILE__))

extend_model 'ApplicationController' do
  include ModifyTheme
end

extend_model :User do
  include UserExtension::SuperAdmin
  include UserExtension::Sorting
end

