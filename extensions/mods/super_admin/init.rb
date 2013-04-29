
self.override_views = false
self.load_once = false

Rails.application.config.to_prepare do
  #require 'super_admin_listener'
end

apply_mixin_to_model(Site, SiteExtension)
apply_mixin_to_model(Request, RequestExtension)
apply_mixin_to_model(RequestToJoinUs, RequestToJoinUsExtension)

require File.expand_path('routes', File.dirname(__FILE__))

# this isn't necessary:
#apply_mixin_to_model(User, UserExtension::SuperAdmin)
# because this is in the core user model:
#  include UserExtension::SuperAdmin rescue NameError
