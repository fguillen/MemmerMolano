require "test_helper"

class VideoTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert FactoryGirl.create(:video, :pic => File.new(fixture("/images/extras1.jpg"))).valid?
  end

  def test_create_with_pic
    performance = FactoryGirl.create(:performance)

    video =
      FactoryGirl.create(
        :video,
        :pic => File.new(fixture("/images/extras1.jpg")),
        :performance => performance
      )

    assert_equal(performance, video.performance)
    assert_equal(1, performance.videos.count)
    assert_equal("extras1.jpg", video.pic_file_name)
    assert_equal(3287, video.pic_file_size)
    assert_match("/uploads/test/videos/pic_#{video.id}_big.jpg", video.pic(:big))
    assert_match("/uploads/test/videos/pic_#{video.id}_slider.jpg", video.pic(:slider))
  end

  def test_on_create_get_last_position
    video_1 = FactoryGirl.create(:video, :position => 10, :pic => File.new(fixture("/images/extras1.jpg")))
    video_2 = FactoryGirl.create(:video, :pic => File.new(fixture("/images/extras1.jpg")))

    assert_equal(11, video_2.position)
  end

  def test_to_param
    video = FactoryGirl.create(:video, :title => "This is the title", :pic => File.new(fixture("/images/extras1.jpg")))
    assert_equal("#{video.id}-this-is-the-title", video.to_param)
  end

  def test_to_json
    video =
      FactoryGirl.create(
        :video,
        :pic => File.new(fixture("/images/extras1.jpg")),
        :title => "Wadus title",
        :text => "Wadus text",
        :script => "Wadus script"
      )

    video_json = video.to_json
    assert_equal("Wadus title", video_json["title"])
    assert_equal("Wadus text", video_json["text"])
    assert_equal("Wadus script", video_json["script"])
    assert_match("/uploads/test/videos/pic_#{video.id}_slider.jpg", video_json["pic_url"])
    assert_equal("/front/performances/#{video.performance.id}-performance-title/videos/#{video.id}-wadus-title", video_json["video_url"])
  end
end
