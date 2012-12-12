require "test_helper"

class Admin::PerformanceCreateTwoNewExtraVideosIntegrationTestTest < ActionDispatch::IntegrationTest
  def test_create_two_new_extra_videos_both_should_be_shown
    performance = FactoryGirl.create(:performance)
    visit edit_admin_performance_path(performance)

    performance_create_new_extra_video(:title => "Video title 1")

    sleep 1
    video_1 = Video.last
    assert_equal("Video title 1", video_1.title)
    assert_equal( "Video title 1", find("#video_extra_#{video_1.id} h3.video_extra_title").text)

    performance_create_new_extra_video(:title => "Video title 2")

    sleep 1
    video_2 = Video.last
    assert_equal("Video title 2", video_2.title)
    assert_equal( "Video title 1", find("#video_extra_#{video_1.id} h3.video_extra_title").text)
    assert_equal( "Video title 2", find("#video_extra_#{video_2.id} h3.video_extra_title").text)
  end

  def test_create_two_new_extra_videos_second_time_the_fields_shoulbe_empty
    performance = FactoryGirl.create(:performance)
    visit edit_admin_performance_path(performance)

    performance_create_new_extra_video

    sleep 1

    # second open
    click_link "Add New Extra Video"
    assert_equal( "", find("#video_popup_new #video_title").value)
    assert_equal( "", find("#video_popup_new #video_pic").value)
    assert_equal( "", find("#video_popup_new #video_script").value)
    assert_equal( "", find("#video_popup_new #video_text").value)
  end
end