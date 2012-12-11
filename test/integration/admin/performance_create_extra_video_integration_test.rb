require "test_helper"

class Admin::PerformanceCreateExtraVideoIntegrationTestTest < ActionDispatch::IntegrationTest
  def test_create_two_new_extra_video_with_errors
    performance = FactoryGirl.create(:performance)
    visit edit_admin_performance_path(performance)

    assert_difference "Video.count", 0 do
      performance_create_new_extra_video(:title => "")
    end

    sleep 1

    assert page.has_content?("Title can't be blank")
  end
end