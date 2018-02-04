$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'todoable'

require 'minitest/autorun'

# Setup mocking for the HTTP client used during tests. Avoid making extra calls
# to the API.
Excon.defaults[:mock] = true
