class Admin::AdminController < ApplicationController
  before_filter :authenticate
  layout "/admin/layouts/admin"

  protected
    def authenticate
      return if Rails.env.test?

      authenticate_or_request_with_http_basic do |username, password|
        username == APP_CONFIG[:user] && password == APP_CONFIG[:pass]
      end
    end
end