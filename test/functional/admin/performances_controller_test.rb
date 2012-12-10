require "test_helper"

class Admin::PerformancesControllerTest < ActionController::TestCase
  def test_index
    performance_1 = FactoryGirl.create(:performance, :position => 1)
    performance_2 = FactoryGirl.create(:performance, :position => 3)
    performance_3 = FactoryGirl.create(:performance, :position => 2)

    get :index

    assert_template "index"
    assert_equal(3, assigns(:performances).length)
    assert_equal([performance_1, performance_3, performance_2].map(&:id), assigns(:performances).map(&:id))
  end

  def test_new
    get :new
    assert_template "new"
  end

  def test_create_invalid
    Performance.any_instance.stubs(:valid?).returns(false)

    post :create
    assert_template "new"
    assert_not_nil(flash[:alert])
  end

  def test_create_valid
    post(
      :create,
      :performance => {
        :title => "Wadus Performance"
      }
    )

    performance = Performance.last

    assert_redirected_to edit_admin_performance_path(performance)
    assert_not_nil(flash[:notice])
    assert_equal("Wadus Performance", performance.title)
  end

  def test_edit
    performance = FactoryGirl.create(:performance)
    get :edit, :id => performance
    assert_template "edit"
  end

  def test_update_invalid
    performance = FactoryGirl.create(:performance)

    put(
      :update,
      :id => performance,
      :performance => {
        :title => ""
      }
    )

    assert_response :success
    assert_equal("application/json", response.content_type)
    assert_equal(1, JSON.parse(response.body)["errors"].length)
  end

  def test_update_valid
    performance = FactoryGirl.create(:performance)

    put(
      :update,
      :id => performance,
      :performance => {
        :title => "Wadus Title",
        :text => "Wadus Text",
        :video_script => "Wadus Video Script",
        :position => 10
      }
    )

    assert_response :success
    assert_equal("application/json", response.content_type)
    assert_equal("ok", JSON.parse(response.body)["state"])

    performance.reload
    assert_equal("Wadus Title", performance.title)
    assert_equal("Wadus Text", performance.text)
    assert_equal("Wadus Video Script", performance.video_script)
    assert_equal(10, performance.position)
  end

  def test_destroy
    performance = FactoryGirl.create(:performance)

    delete :destroy, :id => performance

    assert_redirected_to admin_performances_url
    assert_not_nil(flash[:notice])

    assert !Performance.exists?(performance.id)
  end

  def test_reorder
    performance_1 = FactoryGirl.create(:performance, :position => 10)
    performance_2 = FactoryGirl.create(:performance, :position => 20)

    post(
      :reorder,
      :ids => [performance_2, performance_1].map(&:id)
    )

    performance_1.reload
    performance_2.reload

    assert_equal(1, performance_1.position)
    assert_equal(0, performance_2.position)
  end
end
