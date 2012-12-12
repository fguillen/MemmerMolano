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

  def test_to_param
    performance = FactoryGirl.create(:performance, :title => "This is the title")
    assert_equal("#{performance.id}-this-is-the-title", performance.to_param)
  end

  def test_validation_by_form_section
    performance = FactoryGirl.build(:performance, :title => nil, :text => nil, :video_script => nil, :video_text => nil)
    assert_equal(true, performance.valid?)

    performance = FactoryGirl.build(:performance, :form_section => "new", :title => nil, :text => nil, :video_script => nil, :video_text => nil)
    assert_equal(false, performance.valid?)

    performance = FactoryGirl.build(:performance, :form_section => "new", :title => "the title", :text => nil, :video_script => nil, :video_text => nil)
    assert_equal(true, performance.valid?)

    performance = FactoryGirl.build(:performance, :form_section => "details", :title => "the title", :text => nil, :video_script => nil, :video_text => nil)
    assert_equal(false, performance.valid?)

    performance = FactoryGirl.build(:performance, :form_section => "details", :title => nil, :text => "the text", :video_script => nil, :video_text => nil)
    assert_equal(false, performance.valid?)

    performance = FactoryGirl.build(:performance, :form_section => "details", :title => "the title", :text => "the text", :video_script => nil, :video_text => nil)
    assert_equal(true, performance.valid?)

    performance = FactoryGirl.build(:performance, :form_section => "video_main", :title => nil, :text => nil, :video_script => nil, :video_text => nil)
    assert_equal(false, performance.valid?)

    performance = FactoryGirl.build(:performance, :form_section => "video_main", :title => nil, :text => nil, :video_script => "video script", :video_text => nil)
    assert_equal(false, performance.valid?)

    performance = FactoryGirl.build(:performance, :form_section => "video_main", :title => nil, :text => nil, :video_script => nil, :video_text => "video text")
    assert_equal(false, performance.valid?)

    performance = FactoryGirl.build(:performance, :form_section => "video_main", :title => nil, :text => nil, :video_script => "video script", :video_text => "video text")
    assert_equal(true, performance.valid?)
  end
end
