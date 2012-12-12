require "test_helper"

class Front::PagesControllerTest < ActionController::TestCase
  def test_show_about
    get :show, :id => "about"
    assert_template "front/pages/about"
  end
end
