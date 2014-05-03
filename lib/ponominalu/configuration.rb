module Ponominalu
  module Configuration
    # Default global options
    DEFAULT_OPTIONS = {
      adapter: Faraday.default_adapter,
      session: '123',
      max_retries: 2,
      empty_strict: false,
      raw: false,
      http_verb: :post,
      faraday_options: {}
    }.freeze

    attr_accessor *DEFAULT_OPTIONS.keys

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

    # Reset configuration options to defaults.
    def reset
      @adapter         = DEFAULT_OPTIONS[:adapter]
      @session         = DEFAULT_OPTIONS[:session]
      @max_retries     = DEFAULT_OPTIONS[:max_retries]
      @empty_strict    = DEFAULT_OPTIONS[:empty_strict]
      @raw             = DEFAULT_OPTIONS[:raw]
      @http_verb       = DEFAULT_OPTIONS[:http_verb]
      @faraday_options = DEFAULT_OPTIONS[:faraday_options]
      # @logger          = ::Logger.new(STDOUT)
      # @log_requests    = DEFAULT_LOGGER_OPTIONS[:requests]
      # @log_errors      = DEFAULT_LOGGER_OPTIONS[:errors]
      # @log_responses   = DEFAULT_LOGGER_OPTIONS[:responses]
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
        OPTIONS_KEYS.each do |k|
          send("#{k}=", options[k])
        end
      end
  end
end
