::YUCKY_RATING = -100

self.override_views = false
self.load_once = false


Rails.application.config.to_prepare do
  Page.class_eval do
    acts_as_rateable
  end

  require 'moderation_listener'
  require 'page_view_listener'


  # apply_mixin_to_model(Site, ModerationSiteExtension)
  # apply_mixin_to_model(Page, PageFlagExtension)
  # apply_mixin_to_model(Post, PostFlagExtension)
  # apply_mixin_to_model(Group, GroupModerationExtension)

  extend_model :User do
    include Crabgrass::Moderation::Extends::User
  end
end

