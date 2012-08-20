# https://github.com/plataformatec/devise#test-helpers
RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
end
