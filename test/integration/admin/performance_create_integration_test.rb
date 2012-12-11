
require "test_helper"

class Admin::PerformanceCreateIntegrationTestTest < ActionDispatch::IntegrationTest
  def test_create_performance
    visit admin_performances_path
    click_link "Add New Performance"

    fill_in "performance_title", :with => "This is the new performance"
    click_button "Create Performance"

    performance = Performance.last
    assert_equal("This is the new performance", performance.title)

    page.has_content?("Successfully created performance")

    # Details
    fill_in "performance_title", :with => "I'm changing the title"
    fill_in "performance_text", :with => "This is the description"
    click_button "button_details"

    performance.reload
    assert_equal("I'm changing the title", performance.title)
    assert_equal("This is the description", performance.text)

    # Video
    fill_in "performance_video_script", :with => "Video script"
    fill_in "performance_video_text", :with => "Video description"
    click_button "button_video"

    performance.reload
    assert_equal("Video script", performance.video_script)
    assert_equal("Video description", performance.video_text)

    # Extra Video
    click_link "New Extra Video"
    fill_in "video_title", :with => "Video title"

    page.execute_script %{ $("#video_pic").css({ display: "block" }); }
    attach_file "video_pic", fixture("/images/extras1.jpg")
    page.execute_script %{ $("#video_pic").css({ display: "none" }); }

    fill_in "video_script", :with => "Video script"
    fill_in "video_text", :with => "Video description"
    click_button "Create the new Extra Video"

    sleep 1
    video = Video.last
    assert_equal("Video title", video.title)

    page.has_content?("<h3>Video title</h3>")


  end
end
