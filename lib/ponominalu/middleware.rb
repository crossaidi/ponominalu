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

      if Ponominalu.log_requests?
        @logger.debug "Ponominalu: #{@method_name.upcase} #{env[:url].to_s}"
        @logger.debug "session: #{Ponominalu.session} params: #{@params}"
      end

      env.body << "&session=#{Ponominalu.session}"
      super
    end

    # Passes the user params and handle request errors
    # @param [Hash] env Response data.
    def on_complete(env)
      if env.status == 200
        response_arr = env.body[1..-2].split(',')
          .push("\"method_name\": \"#{@method_name}\"")
          .push("\"session\": \"#{Ponominalu.session}\"")
          .push("\"params\": #{Oj.dump(@params)}")

        env.body = "{#{response_arr.join(',')}}"
      else
        @logger.error "Request failed with status code #{env.status}."
        raise "Request failed with status code #{env.status}."
      end
    end
  end
end

Faraday::Response.register_middleware pn:
  Ponominalu::Middleware
