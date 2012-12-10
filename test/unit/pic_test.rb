require 'test_helper'

class PicTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert FactoryGirl.create(:pic).valid?
  end

  def test_on_create_get_last_position
    pic_1 = FactoryGirl.create(:pic, :position => 10)
    pic_2 = FactoryGirl.create(:pic)

    assert_equal(11, pic_2.position)
  end

  def test_to_json
    pic = FactoryGirl.create(:pic, :thumb => File.new(fixture("/images/1.jpg")))

    pic_json = pic.to_json

    assert_equal(pic.id, pic_json["id"])
    assert_match("/uploads/test/performances/pic_#{pic.id}_admin.jpg", pic_json["file_url"])
  end

end
