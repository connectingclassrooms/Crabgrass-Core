require_relative '../../../../test/test_helper'

# Engines::Testing.set_fixture_path

def setup_site_with_moderation
    @mod = FactoryGirl.create :user, login: "mod"
    @mods = FactoryGirl.create :group
    @mods.add_user! @mod
    @site = FactoryGirl.create :site,
      moderation_group: @mods,
      name: "moderation",
      domain: "test.host"
end

#class Test::Unit::TestCase
#  self.use_transactional_fixtures = true
#  self.use_instantiated_fixtures  = false
#  fixtures :all
#end
