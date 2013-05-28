require_relative '../test_helper'

class ModeratePostsTest < ActiveSupport::TestCase
  include ModerationTestHelper

  setup do
    @post = FactoryGirl.create :post
    @user = FactoryGirl.create :user
    @flag = @post.moderated_flags.where(user_id: @user).create
  end

  test "flagged post shows up in new" do
    assert_in_state :new, @post
  end

  test "flagged and deleted post shows up in deleted" do
    @post.delete
    assert_in_state :deleted, @post
  end

  test "flagged and vetted post shows up in vetted" do
    @post.vetted = true
    @post.save
    assert_in_state :vetted, @post
  end
end
