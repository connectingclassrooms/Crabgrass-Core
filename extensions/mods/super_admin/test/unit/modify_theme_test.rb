require_relative '../test_helper'

class ModifyThemeTest < ActiveSupport::TestCase

  setup do
    @controller = ApplicationController.new
    @controller.stubs(:current_site).returns(stub(theme: 'default'))
  end

  test "no admin menu without modify theme" do
    assert theme = @controller.send(:current_theme)
    assert_nil theme.navigation.root.seek :admin
  end

  test "modify theme to include admin menu" do
    @controller.send :modify_theme
    assert theme = @controller.send(:current_theme)
    assert theme.navigation.root.seek :admin
    theme.reload!
  end

end
