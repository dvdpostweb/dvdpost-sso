class ApplicationController < ActionController::Base
  include ApplicationHelper
  # protect_from_forgery
  layout 'application'

  def after_sign_out_path_for(resource_or_scope)
    login_path
  end
end
