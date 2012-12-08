require "test_helper"

class Front::PerformancesControllerTest < ActionController::TestCase
  def test_last
    performance_1 = FactoryGirl.create(:performance, :position => 1)
    performance_2 = FactoryGirl.create(:performance, :position => 3)
    performance_3 = FactoryGirl.create(:performance, :position => 2)

    get :last

    assert_redirected_to [:front, performance_2]
  end

  def test_show
    performance = FactoryGirl.create(:performance)
    get :show, :id => performance
    assert_template "front/performances/show"
    assert_equal(performance, assigns(:performance))
  end

  def test_extras
    performance = FactoryGirl.create(:performance)
    video = FactoryGirl.create(:video, :performance => performance)
    get :extras, :id => performance
    assert_template "front/performances/extras"
    assert_equal(performance, assigns(:performance))
  end

  def test_video
    performance = FactoryGirl.create(:performance)
    get :video, :id => performance
    assert_template "front/performances/video"
    assert_equal(performance, assigns(:performance))
  end
end
