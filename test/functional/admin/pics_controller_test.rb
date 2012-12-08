require "test_helper"

class Admin::PicsControllerTest < ActionController::TestCase
  def test_index
    performance = FactoryGirl.create(:performance)
    pic_1 = FactoryGirl.create(:pic, :performance => performance, :thumb => File.new(fixture("/images/1.jpg")))
    pic_2 = FactoryGirl.create(:pic, :performance => performance, :thumb => File.new(fixture("/images/2.jpg")))

    get(:index, :performance_id => performance)

    assert_response :success
    assert_equal("application/json", response.content_type)
    assert_equal("xxx", JSON.parse(response.body).first["url"])
    assert_equal("xxx", JSON.parse(response.body).last["url"])
  end

  def test_create
    performance = FactoryGirl.create(:performance)

    post(
      :create,
      :performance_id => performance,
      :file => fixture_file_upload("/images/extras1.jpg")
    )

    pic = Pic.last

    assert_response :success
    assert_equal("application/json", response.content_type)
    assert_equal("xxx", JSON.parse(response.body)["url"])
  end

  def test_destroy
    performance = FactoryGirl.create(:performance)
    pic = FactoryGirl.create(:pic, :performance => performance)

    delete(
      :destroy,
      :performance_id => performance,
      :id => pic
    )

    assert_response :success
    assert_equal("application/json", response.content_type)
    assert_equal("ok", JSON.parse(response.body)["state"])

    assert !Pic.exists?(pic.id)
  end
end
