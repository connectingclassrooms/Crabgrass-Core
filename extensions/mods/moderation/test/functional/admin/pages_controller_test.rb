require_relative '../../test_helper'

class Admin::PagesControllerTest < ActionController::TestCase

  fixtures :pages

  def setup
    setup_site_with_moderation
  end

  def test_index_view
    with_site "moderation" do
      login_as @mod
      get :index
      assert_response :success
      assert_not_nil assigns(:flagged)
    # run through all the different possible views
      ['vetted', 'deleted', 'new', 'public requested', 'public', 'all'].each do |view|
        get :index, :view => view
        assert_response :success
        assert_not_nil assigns(:flagged), "no pages for #{view}"
      end
    end
  end

  def test_update
    with_site "moderation" do
      login_as @mod
      page = FactoryGirl.create :page
      # test change moderation flags should be possible never the less.
      [:public, :vetted].each do |para|
        post :update, :id => page.id, :page => {para => true}
        assert_response :redirect
        assert_redirected_to :action => 'index'
        assert page.reload.send("#{para.to_s}?")
      end
      [:public, :vetted].each do |para|
        post :update, :id => page.id, :page => {para => false}
        assert_response :redirect
        assert_redirected_to :action => 'index'
        assert !page.reload.send("#{para.to_s}?")
      end
    end
  end

  def test_update_restricted_to_moderation
    with_site "moderation" do
      login_as @mod
      page = FactoryGirl.create :page
      old_title = page.title
      post :update, :id => page.id, :page => {:title => "pwned"}
      assert_equal old_title, page.reload.title,
        "Moderator should not be able to change site content."
    end
  end

  def test_update_restricted_to_moderators
    with_site "moderation" do
      user = FactoryGirl.create :user
      login_as user
      page = FactoryGirl.create :page
      assert !page.vetted
      post :update, :id => page.id, :page => {:vetted => true}
      assert !page.vetted,
        "normal user may not moderate the page."
    end
  end

end
