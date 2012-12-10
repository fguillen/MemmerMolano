require 'test_helper'

class Admin::PerformancesReorderIntegrationTestTest < ActionDispatch::IntegrationTest
  def test_reorder
    performance_1 = FactoryGirl.create(:performance)
    performance_2 = FactoryGirl.create(:performance)
    performance_3 = FactoryGirl.create(:performance)

    visit admin_performances_path

    page.execute_script %{ $("tr##{performance_2.id}").simulateDragSortable({ move: 1, handle: ".handle" }); }

    performance_1.reload
    performance_2.reload
    performance_3.reload
    assert_equal(3, performance_1.position)
    assert_equal(3, performance_2.position)
    assert_equal(3, performance_3.position)
  end
end
