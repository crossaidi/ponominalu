require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/parse_oj'
require 'yaml'

require 'ponominalu/configuration'
require 'ponominalu/helpers'
require 'ponominalu/middleware'
require 'ponominalu/api'
require 'ponominalu/response'
require 'ponominalu/error'

module Ponominalu
  extend Configuration

  class << self
    def method_missing(method, *args, &block)
      API.call_method(method, *args, &block)
    end
  end
end
