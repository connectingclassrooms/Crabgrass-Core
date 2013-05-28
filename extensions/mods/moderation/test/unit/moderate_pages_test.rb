require_relative '../test_helper'

class ModeratePagesTest < ActiveSupport::TestCase
  include ModerationTestHelper

  setup do
    @page = FactoryGirl.create :page
    @user = FactoryGirl.create :user
    @flag = @page.moderated_flags.where(user_id: @user).create
  end

  test "flagged page shows up in new" do
    assert_in_state :new, @page
  end

  test "flagged and deleted page shows up in deleted" do
    @page.delete
    assert_in_state :deleted, @page
  end

  test "flagged and vetted page shows up in vetted" do
    @page.update_attributes vetted: true
    assert_in_state :vetted, @page
  end
end
