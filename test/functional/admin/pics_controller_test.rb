require "test_helper"

class Admin::PicsControllerTest < ActionController::TestCase
  def test_index
    performance = FactoryGirl.create(:performance)
    pic_1 = FactoryGirl.create(:pic, :performance => performance, :thumb => File.new(fixture("/images/1.jpg")))
    pic_2 = FactoryGirl.create(:pic, :performance => performance, :thumb => File.new(fixture("/images/2.jpg")))

    get(:index, :performance_id => performance)

    assert_response :success
    assert_equal("application/json", response.content_type)
    assert_match("pic_#{pic_1.id}_admin.jpg", JSON.parse(response.body).first["file_url"])
    assert_match("pic_#{pic_2.id}_admin.jpg", JSON.parse(response.body).last["file_url"])
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
    assert_match("pic_#{pic.id}_admin.jpg", JSON.parse(response.body)["file_url"])
  end

  def test_destroy
    performance = FactoryGirl.create(:performance)
    pic = FactoryGirl.create(:pic, :performance => performance, :thumb => File.new(fixture("/images/2.jpg")))

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

  def test_reorder
    performance = FactoryGirl.create(:performance)
    pic_1 = FactoryGirl.create(:pic, :position => 1, :performance => performance, :thumb => File.new(fixture("/images/2.jpg")))
    pic_2 = FactoryGirl.create(:pic, :position => 2,:performance => performance, :thumb => File.new(fixture("/images/2.jpg")))
    pic_3 = FactoryGirl.create(:pic, :position => 3,:performance => performance, :thumb => File.new(fixture("/images/2.jpg")))

    performance.reload
    assert_equal([pic_1, pic_2, pic_3].map(&:id), performance.pics.by_position.map(&:id))

    post(
      :reorder,
      :performance_id => performance,
      :ids => [pic_2, pic_3, pic_1].map(&:id)
    )

    performance.reload
    assert_equal([pic_2, pic_3, pic_1].map(&:id), performance.pics.by_position.map(&:id))
  end
end
