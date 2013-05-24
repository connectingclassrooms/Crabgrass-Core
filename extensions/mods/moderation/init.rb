::YUCKY_RATING = -100

self.override_views = false
self.load_once = false


Rails.application.config.to_prepare do
  require File.expand_path('routes', File.dirname(__FILE__))

  Page.class_eval do
    acts_as_rateable
  end

end

# require 'moderation_listener'
# require 'page_view_listener'


# apply_mixin_to_model(Site, ModerationSiteExtension)
# apply_mixin_to_model(Page, PageFlagExtension)
# apply_mixin_to_model(Post, PostFlagExtension)
# apply_mixin_to_model(Group, GroupModerationExtension)

extend_model :Site do
  include Crabgrass::Moderation::Extends::Site
end

extend_model :User do
  include Crabgrass::Moderation::Extends::User
end
