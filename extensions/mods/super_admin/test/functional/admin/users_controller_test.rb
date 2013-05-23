require_relative '../../test_helper'

class Admin::UsersControllerTest < ActionController::TestCase

  fixtures :users, :sites, :groups, :memberships

  # none of the tests in here were written for the superadmin mod - they
  # all seemed to be a copy of the normal UserControllerTests.
  #  --azul

  def test_successful_creation
    login_as :blue
    assert_difference 'User.count' do
      post_create_form
      assert user = assigns[:user]
      assert user.valid?, user.errors.full_messages.join("\n")
      assert_response :redirect
      assert_redirected_to({:action => :show, :id => user.to_param},
        'creation should succeed.')
    end
  end

  def test_do_not_create_duplicates
    login_as :blue
    assert_no_difference 'User.count' do
      post_create_form :user => {:login => 'blue'}
      assert user = assigns[:user]
      assert user.errors[:login].present?
      assert_error_message
    end
  end

  def test_create_not_matching
    login_as :blue
    post_create_form :user => {:password => 'q'}
    assert_response 422
    assert_error_message
  end

  def test_only_superadmins
    login_as :penguin
    post_create_form
    assert_permission_denied
  end

  def test_index
    inactive = FactoryGirl.create :user
    login_as :blue
    get :index, :show => 'active'
    assert assigns[:users].present?, "no active users found"
    assert (assigns[:users].map(&:login)).include?('red'),
      "red should be in the active users list"
    assert !(assigns[:users].map(&:login)).include?(inactive.login),
      "fresh created user should not be in the active users list."
  end

  protected

  def post_create_form(options = {})
    post(:create, {
      :user => {
         :login => 'quire',
         :email => 'quire@localhost.taz',
         :password => 'quire',
         :password_confirmation => 'quire'
      }.merge(options.delete(:user) || {}),
    }.merge(options))
  end

end
