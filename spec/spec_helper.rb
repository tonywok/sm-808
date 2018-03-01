require "bundler/setup"
require "pry"
Bundler.setup

require "sm_808"
include Sm808

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
end
