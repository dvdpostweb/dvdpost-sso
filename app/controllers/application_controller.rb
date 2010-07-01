class ApplicationController < ActionController::Base
  include ApplicationHelper
  # protect_from_forgery
  layout 'application'
  before_filter :set_locale

  private
  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = params[:locale] || session[:locale]
    session[:locale] = I18n.locale
    logger.info I18n.locale
    # saving the locale in the session is not a good idea, but was the cleanest way for the SSO to work
    # In this case you'll never add I18n
  end

  def default_url_options(options={})
    {:locale => I18n.locale}
  end
end
