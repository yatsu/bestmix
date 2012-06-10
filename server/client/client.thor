require 'net/http'
require 'oauth2'

class Client < Thor
  desc "public_tasks BASE_URL", "get public tasks"
  def public_tasks(base_url)
    uri = URI.parse("#{base_url}/api/v1/tasks/public")
    res = Net::HTTP.get(uri.host, uri.path)
    puts res
  end

  desc "my_tasks BASE_URL, APP_ID, SECRET, TOKEN", "get my tasks"
  def my_tasks(base_url, app_id, secret, token)
    client = OAuth2::Client.new(app_id, secret, site: base_url)
    # client.connection.proxy("http://127.0.0.1:8888") # for Charles
    access = OAuth2::AccessToken.new(client, token)
    res = access.get("/api/v1/tasks/my")
    puts res.inspect
  end

  desc "auth BASE_URL APP_ID SECRET REDIRECT_URL", "authenticate"
  def auth(base_url, app_id, secret, redirect_url)
    client = OAuth2::Client.new(app_id, secret, site: base_url)
    puts "open \"#{client.auth_code.authorize_url(redirect_uri: redirect_url)}\""
    system "open \"#{client.auth_code.authorize_url(redirect_uri: redirect_url)}\""
  end

  desc "auth2 BASE_URL APP_ID SECRET REDIRECT_URL CODE", "authenticate phase 2"
  def auth2(base_url, app_id, secret, redirect_url, code)
    client = OAuth2::Client.new(app_id, secret, site: base_url)
    access = client.auth_code.get_token(code, redirect_uri: redirect_url)
    puts "token: #{access.token}"
  end
end
