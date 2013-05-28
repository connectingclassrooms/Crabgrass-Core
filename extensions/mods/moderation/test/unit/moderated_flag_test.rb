require_relative '../test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @page = FactoryGirl.create :page
    @user = FactoryGirl.create :user
    @flag = @page.moderated_flags.where(user_id: @user).create
  end

  test "flagged page shows up in new" do
    assert_page_in :new
    assert !@flag.deleted_at
    assert !@flag.vetted_at
  end

  test "flagged and deleted page shows up in deleted" do
    @page.delete
    assert_page_in :deleted
  end

  test "deleting a page sets deleted_at for flags" do
    @page.delete
    @flag.reload
    assert @flag.deleted_at
    assert !@flag.vetted_at
  end

  test "flagged and vetted page shows up in vetted" do
    @page.update_attributes vetted: true
    assert_page_in :vetted
  end

  test "vetting a page sets flags" do
    assert @page.update_attributes vetted: true
    @flag.reload
    assert !@flag.deleted_at
    assert @flag.vetted_at
  end

  protected

  MODERATION_STATES = %W/new deleted vetted/

  def assert_page_in(expected)
    MODERATION_STATES.each do |state|
      if state == expected.to_s
        assert page_in(state), "Page should have shown up in #{expected}"
      else
        assert !page_in(state),
          "Page expected in #{expected} should not have shown up in #{state}"
      end
    end
  end

  def page_in(state)
    Page.find_by_path("/moderation/#{state}").include?(@page)
  end

end


