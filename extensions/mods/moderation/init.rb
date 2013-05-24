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


extend_model :Site do
  include Crabgrass::Moderation::Extends::Site
end

extend_model :User do
  include Crabgrass::Moderation::Extends::User
end

extend_model :Page do
  include Crabgrass::Moderation::Extends::Page
end

extend_model :Post do
  include Crabgrass::Moderation::Extends::Post
end

extend_model :Group do
  include Crabgrass::Moderation::Extends::Group
end
