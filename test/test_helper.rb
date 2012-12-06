ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require_relative "factories"

class ActiveSupport::TestCase
  FIXTURES_PATH = "#{File.dirname(__FILE__)}/fixtures"

  def fixture(fixture_path)
    File.expand_path "#{FIXTURES_PATH}/#{fixture_path}"
  end
end
