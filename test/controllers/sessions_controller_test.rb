require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def test_signin_page
    assert_select 'Sign in'
  end
end
