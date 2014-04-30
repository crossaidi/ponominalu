# Binding.pry
require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/parse_oj'

require 'ponominalu/configuration'
require 'ponominalu/api'
require 'ponominalu/client'

module Ponominalu
  extend Configuration

  class << self
    def client(options=nil, &block)
      @client ||= Client.new(options, &block)
    end

    def method_missing(method, *args, &block)
      # return super unless client.respond_to?(method)
      client.send(method, *args, &block)
    end

    def respond_to?(method)
      return client.respond_to?(method) || super
    end

    def reset
      @client = nil
    end
  end
end
