require "test_helper"

class Admin::VideosControllerTest < ActionController::TestCase
  def test_index
    performance = FactoryGirl.create(:performance)
    video_1 = FactoryGirl.create(:video, :performance => performance, :title => "video_1")
    video_2 = FactoryGirl.create(:video, :performance => performance)

    get(
      :index,
      :performance_id => performance
    )

    assert_response :success
    assert_equal("application/json", response.content_type)
    assert_equal(2, JSON.parse(response.body).length)
    assert_equal("video_1", JSON.parse(response.body).first["title"])
  end

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
          :pic => fixture_file_upload("/images/1.jpg"),
          :position => "2"
        }
      )
    end

    video = Video.last

    assert_response :success
    assert_equal("application/json", response.content_type)
    assert_equal("Wadus title", JSON.parse(response.body)["title"])

    assert_equal("Wadus title", video.title)
    assert_equal("Wadus script", video.script)
    assert_equal("Wadus text", video.text)
    assert_equal(2, video.position)
    assert_equal(performance, video.performance)
    assert_equal(video, performance.videos.first)
  end

  def test_create_invalid
    performance = FactoryGirl.create(:performance)

    assert_difference "Video.count", 0 do
      post(
        :create,
        :performance_id => performance,
        :video => {}
      )
    end

    assert_response :success
    assert_equal("application/json", response.content_type)
    assert_equal(4, JSON.parse(response.body)["errors"].length)
  end

  def test_destroy
    performance = FactoryGirl.create(:performance)
    video = FactoryGirl.create(:video, :performance => performance)

    assert_difference "Video.count", -1 do
      delete(
        :destroy,
        :performance_id => performance,
        :id => video
      )
    end

    assert_response :success
    assert_equal("application/json", response.content_type)
    assert_equal("ok", JSON.parse(response.body)["status"])

    assert !Video.exists?(video.id)
  end

  def test_reorder
    performance = FactoryGirl.create(:performance)
    video_1 = FactoryGirl.create(:video, :position => 10, :performance => performance)
    video_2 = FactoryGirl.create(:video, :position => 20, :performance => performance)

    post(
      :reorder,
      :performance_id => performance,
      :ids => [video_2, video_1].map(&:id)
    )

    assert_response :success
    assert_equal("application/json", response.content_type)
    assert_equal("ok", JSON.parse(response.body)["status"])

    video_1.reload
    video_2.reload

    assert_equal(1, video_1.position)
    assert_equal(0, video_2.position)
  end
end
