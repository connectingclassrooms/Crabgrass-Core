::YUCKY_RATING = -100

self.override_views = false
self.load_once = false


Rails.application.config.to_prepare do
  require File.expand_path('routes', File.dirname(__FILE__))

  Page.class_eval do
    acts_as_rateable
  end

  Common::Application::BeforeFilters.module_eval do
    include Crabgrass::Moderation::ModifyTheme
  end

  Pages::SidebarHelper.module_eval do
    include Crabgrass::Moderation::PageSidebarActions
  end

  Common::Ui::PostHelper.module_eval do
    include Crabgrass::Moderation::PostActions
  end
end

require 'crabgrass/moderation/search_filter'
# require 'moderation_listener'
# require 'page_view_listener'


extend_model :Site do
  include Crabgrass::Moderation::Extends::Site
end

extend_model :User do
  include Crabgrass::Moderation::Extends::User
end

extend_model :Page do
  include Crabgrass::Moderation::Extends::Moderated
end

extend_model :Post do
  include Crabgrass::Moderation::Extends::Moderated
end

extend_model :Group do
  include Crabgrass::Moderation::Extends::Group
end
