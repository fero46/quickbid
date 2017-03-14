ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require File.dirname(__FILE__) + "/factories"

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

end