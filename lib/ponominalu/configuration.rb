require 'logger'

module Ponominalu
  module Configuration
    # Default global options
    DEFAULT_OPTIONS = {
      adapter: Faraday.default_adapter,
      session: '123',
      max_retries: 2,
      empty_strict: false,
      raw_json: false,
      logger: ::Logger.new(STDOUT),
      log_requests: true,
      log_errors: true,
      log_responses: false,
      wrap_response: false,
      http_verb: :post,
      faraday_options: {}
    }.freeze

    attr_accessor *DEFAULT_OPTIONS.keys

    alias_method :log_requests?,  :log_requests
    alias_method :log_errors?,    :log_errors
    alias_method :log_responses?, :log_responses

    # A global configuration set via the block or hash.
    # @param [Hash] options Hash of options
    # @example
    #   Ponominalu.configure do |config|
    #     config.adapter = :net_http
    #     config.logger  = Rails.logger
    #   end
    def configure(options={})
      configure_by_hash(options) unless options.empty?
      yield self if block_given?
      self
    end

    # Reset configuration options to default values.
    def reset
      DEFAULT_OPTIONS.each do |k, v|
        send("#{k}=", v)
      end
    end

    # Set configuration options to their default values,
    # when this module is extended.
    def self.extended(base)
      base.reset
    end

    private
      # Configures global options via hash
      # @param [Hash] options Hash of options
      def configure_by_hash(options)
        DEFAULT_OPTIONS.keys.each do |k|
          send("#{k}=", options[k])
        end
      end
  end
end
