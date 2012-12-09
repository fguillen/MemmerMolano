require "test_helper"

class PerformanceTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert FactoryGirl.create(:performance).valid?
  end

  def test_add_pic
    performance = FactoryGirl.create(:performance)

    pic =
      FactoryGirl.create(
        :pic,
        :thumb => File.new(fixture("/images/1.jpg")),
        :performance => performance
      )

    assert_equal(performance, pic.performance)
    assert_equal(1, performance.pics.count)
    assert_equal("1.jpg", pic.thumb_file_name)
    assert_equal(81757, pic.thumb_file_size)
    assert_match("/uploads/test/performances/pic_#{pic.id}_full.jpg", pic.thumb(:full))
    assert_match("/uploads/test/performances/pic_#{pic.id}_slider.jpg", pic.thumb(:slider))
  end

  def test_on_create_get_last_position
    performance_1 = FactoryGirl.create(:performance, :position => 10)
    performance_2 = FactoryGirl.create(:performance)

    assert_equal(11, performance_2.position)
  end
end
