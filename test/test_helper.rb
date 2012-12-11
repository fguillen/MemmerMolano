ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require_relative "factories"

DatabaseCleaner.strategy = :truncation

class ActiveSupport::TestCase
  FIXTURES_PATH = "#{File.dirname(__FILE__)}/fixtures"

  def fixture(fixture_path)
    File.expand_path "#{FIXTURES_PATH}/#{fixture_path}"
  end
end

require "capybara/rails"

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  self.use_transactional_fixtures = false

  def setup
    Capybara.current_driver = Capybara.javascript_driver # :selenium by default
    Capybara.default_selector = :css
  end

  def teardown
    DatabaseCleaner.clean       # Truncate the database
    Capybara.reset_sessions!    # Forget the (simulated) browser state
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
  end

  def performance_create_new_extra_video(opts = {})
    opts =
      opts.reverse_merge(
        :title => "Video title",
        :pic => "/images/extras1.jpg",
        :script => "Video script",
        :text => "Video text"
      )

    click_link "Add New Extra Video"
    find("#video_popup_new #video_title").set(opts[:title])
    find("#video_popup_new #video_pic").set(fixture(opts[:pic]))
    find("#video_popup_new #video_script").set(opts[:script])
    find("#video_popup_new #video_text").set(opts[:text])
    find("#video_popup_new .submit").click
  end

end