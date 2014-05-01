require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/parse_oj'
require 'pry'

require 'ponominalu/configuration'
require 'ponominalu/api'
require 'ponominalu/client'
require 'ponominalu/response'

module Ponominalu
  extend Configuration

  class << self
    def client
      @client ||= Client.new
    end

    def method_missing(method, *args, &block)
      client.send(method, *args, &block)
    end
  end
end
