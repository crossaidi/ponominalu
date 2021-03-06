module Ponominalu
  # Faraday middleware for a passing the session param to the request
  # and config data to the response.
  # Also it handles errors
  class Middleware < Faraday::Response::Middleware
    # Passes the session param
    # @param [Hash] env Request data.
    def initialize(app)
      super(app)
      @session = Ponominalu.session
      @logger = Ponominalu.logger
    end

    def call(env)
      # Parse the params and the method name from request body
      @method_name = env.url.to_s.split('/').last
      @params = Helpers.parse_params(env.body)

      if Ponominalu.log_requests?
        @logger.debug "Ponominalu: #{@method_name.upcase} #{env.url.to_s}"
        @logger.debug "session: #{@session} params: #{@params}"
      end

      # Add the session to the user request params
      env.body << "&session=#{@session}"
      super
    end

    # Passes the user params and handle request errors
    # @param [Hash] env Response data.
    def on_complete(env)
      if env.status != 200
        if Ponominalu.log_errors?
          @logger.warn "Request failed with status code #{env.status}."
        end
        raise "Request failed with status code #{env.status}."
      end

      config_data = {
        method_name: @method_name,
        params: @params,
        session: @session
      }

      env.body = Hashie::Mash.new(Oj.load(env.body).merge(config_data))

      if env.body.code.zero? && !Ponominalu.empty_strict
        if Ponominalu.log_errors?
          @logger.warn 'Nothing was found. Result is empty.'
        end
      elsif env.body.code < 1
        if Ponominalu.log_errors?
          @logger.warn "#{env.body.code}: #{env.body.message}."
        end
        raise Ponominalu::Error.new(env.body)
      else
        @logger.debug "body: #{env.body}" if Ponominalu.log_responses?
      end
    end
  end
end

Faraday::Response.register_middleware ponominalu:
  Ponominalu::Middleware
