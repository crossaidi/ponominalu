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

      env.body << "&session=#{Ponominalu.session}"
      super
    end

    # Passes the user params and handle request errors
    # @param [Hash] env Response data.
    def on_complete(env)
      if env.status == 200
        response_arr = env.body[1..-2].split(',')
        response_arr << "\"method_name\": \"#{@method_name}\""
        response_arr << "\"session\": \"#{Ponominalu.session}\""
        response_arr << "\"params\": #{Oj.dump(@params)}"

        env.body = "{#{response_arr.join(',')}}"
      else
        raise "Request failed with status code #{env.status}."
      end
    end
  end
end

Faraday::Response.register_middleware pn:
  Ponominalu::Middleware
