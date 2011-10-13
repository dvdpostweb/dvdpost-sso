module AuthorizationHelper
  def validate_type(&block)
    if params[:type] == 'web_server'
      yield
    else
      render_bad_request :invalid_client_type
    end
  end

  def validate_client(&block)
    if params[:client_id]
      client = nil
      clients.collect do |c|
        if c.second['client_id'] == params[:client_id]
          client = c.second
        end
      end
      if client and client['client_secret'] == params[:client_secret]
        yield
      else
        render_bad_request :invalid_client_credentials
      end
    else
      render_bad_request :invalid_client_credentials
    end
  end

  def validate_redirect_uri(&block)
    if params[:redirect_uri]
      redirect_uri = URI.parse(params[:redirect_uri])
      valid = nil
      clients.each do |client|
        begin
          uri = URI.parse(client.second['redirect_uri'])
          valid ||= (uri.host == redirect_uri.host) and (uri.port == redirect_uri.port)
        rescue Exception => e
          # if invalid url it should render the bad request
        end
      end
      if valid
        yield
      else
        render_bad_request :redirect_uri_mismatch
      end
    else
      render_bad_request :redirect_uri_mismatch
    end
  end

  def render_unauthorized(message)
    warden.custom_failure!
    render_error :unauthorized, message
  end

  def render_bad_request(message)
    render_error :bad_request, message
  end

  def render_error(status, message)
    logger.error "*** Error: #{status} => #{message} ***"
    render :status => status, :json => {:error => message}
  end

  def clients
    @clients ||= YAML.load(File.read(File.join(Rails.root, 'config', 'oauth2.yml')))
  end
end
