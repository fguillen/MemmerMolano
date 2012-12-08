require "test_helper"

class Front::VideosControllerTest < ActionController::TestCase
  def test_show
    performance = FactoryGirl.create(:performance)
    video = FactoryGirl.create(:video, :performance => performance)

    get(
      :show,
      :performance_id => performance,
      :id => video
    )

    assert_template "front/videos/show"
    assert_equal(video, assigns(:video))
    assert_equal(performance, assigns(:performance))
  end
end
