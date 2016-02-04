# Require config/environment.rb
require ::File.expand_path('../config/environment',  __FILE__)

enable :sessions
set :session_secret, ENV['SESSION_SECRET'] || 'this is a secret shhhhh'

set :app_file, __FILE__

run Sinatra::Application
