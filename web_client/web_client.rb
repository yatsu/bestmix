require 'sinatra/base'

class WebClient < Sinatra::Base
  set :static, true
  set :public_folder, File.dirname(__FILE__)

  get '/' do
    File.read('index.html')
  end
end
