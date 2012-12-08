require "test_helper"

class Admin::VideosControllerTest < ActionController::TestCase
  def test_create
    performance = FactoryGirl.create(:performance)

    assert_difference "Video.count", 1 do
      post(
        :create,
        :performance_id => performance,
        :video => {
          :title => "Wadus title",
          :script => "Wadus script",
          :text => "Wadus text",
          :position => "2"
        }
      )
    end

    video = Video.last

    assert_redirected_to edit_admin_performance_path(performance)
    assert_not_nil(flash[:notice])

    assert_equal("Wadus title", video.title)
    assert_equal("Wadus script", video.script)
    assert_equal("Wadus text", video.text)
    assert_equal(2, video.position)
    assert_equal(performance, video.performance)
    assert_equal(video, performance.videos.first)
  end

  def test_create_invalid
    performance = FactoryGirl.create(:performance)
    Video.any_instance.stubs(:valid?).returns(false)

    assert_difference "Video.count", 0 do
      post(
        :create,
        :performance_id => performance,
        :video => {}
      )
    end

    assert_template "/admin/performances/edit"
    assert_not_nil(flash[:alert])
  end

  def test_destroy
    performance = FactoryGirl.create(:performance)
    video = FactoryGirl.create(:video, :performance => performance, :pic => File.new(fixture("/images/extras2.jpg")))

    assert_difference "Video.count", -1 do
      delete(
        :destroy,
        :performance_id => performance,
        :id => video
      )
    end

    assert_redirected_to edit_admin_performance_path(performance)
    assert_not_nil(flash[:notice])

    assert !Video.exists?(video.id)
  end
end
