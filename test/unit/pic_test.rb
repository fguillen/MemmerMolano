require 'test_helper'

class PicTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert FactoryGirl.create(:pic, :thumb => File.new(fixture("/images/1.jpg"))).valid?
  end

  def test_on_create_get_last_position
    pic_1 = FactoryGirl.create(:pic, :position => 10, :thumb => File.new(fixture("/images/1.jpg")))
    pic_2 = FactoryGirl.create(:pic, :thumb => File.new(fixture("/images/1.jpg")))

    assert_equal(11, pic_2.position)
  end

end
