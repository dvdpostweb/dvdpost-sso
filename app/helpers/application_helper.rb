module ApplicationHelper
  def switch_locale_link(locale, options=nil)
    link_to locale.to_s.upcase, params.merge(:locale => locale.to_s.downcase), options
  end

  def callback_url(uri, params)
    if params.empty?
      uri
    else
      query = params.collect{|k,v| "#{k}=#{v}"}.join('&')
      uri = "#{uri}#{uri.match(/\?/) ? '&' : '?'}"
      "#{uri}#{query}"
    end
  end

  def dvdpost_url
    'http://www.dvdpost.be'
  end

  def current_locale
    session[:locale] || I18n.locale
  end
end
