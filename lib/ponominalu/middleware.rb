module Ponominalu
  # Faraday middleware for passing the session param to the request
  # and user params to the response under the hood.
  # Also it handles global request errors
  class Middleware < Faraday::Response::Middleware
    # Passes the session param
    # @param [Hash] env Request data.
    def call(env)
      @method_name = env.url.to_s.split('/').last
      @params = Helpers.parse_params(env.body)
      @logger = Ponominalu.logger
      @session = Ponominalu.session

      if Ponominalu.log_requests?
        @logger.debug "Ponominalu: #{@method_name.upcase} #{env[:url].to_s}"
        @logger.debug "session: #{@session} params: #{@params}"
      end

      # Add session to user request params
      env.body << "&session=#{@session}"
      super
    end

    # Passes the user params and handle request errors
    # @param [Hash] env Response data.
    def on_complete(env)
      if env.status != 200
        @logger.error "Request failed with status code #{env.status}."
        raise "Request failed with status code #{env.status}."
      end

      debug_data = {
        method_name: @method_name,
        params: @params,
        session: @session
      }

      env.body = Hashie::Mash.new(Oj.load(env.body).merge(debug_data))

      if env.body.code.zero? && !Ponominalu.empty_strict
        @logger.warn "Nothing was found. Result is empty." if Ponominalu.log_errors?
      elsif env.body.code < 1
        @logger.error "#{env.body.code}: #{env.body.message}." if Ponominalu.log_errors?
        raise Ponominalu::Error.new(env.body)
      else
        @logger.debug "body: #{env.body}" if Ponominalu.log_responses?
      end
      # binding.pry
    end
  end
end

Faraday::Response.register_middleware pn:
  Ponominalu::Middleware
