module Ponominalu
  # Faraday middleware for passing the session param to the request
  # and user params to the response under the hood
  class ParametersResolver < Faraday::Response::Middleware
    # Passes the session param
    # @param [Hash] env Request data.
    def call(env)
      @method_name = env.url.to_s.split('/').last
      @params = parse_params(env.body)

      env.body << "&session=#{Ponominalu.session}"
      super
    end

    # Passes the user params
    # @param [Hash] env Response data.
    def on_complete(env)
      raise 'API method not found' if env.status == 404

      response_arr = env.body[1..-2].split(',')
      response_arr << "\"method_name\": \"#{@method_name}\""
      response_arr << "\"session\": \"#{Ponominalu.session}\""
      response_arr << "\"params\": #{Oj.dump(@params)}"

      env.body = "{#{response_arr.join(',')}}"
    end

    private
      def parse_params(params)
        params.split('&').inject({}) do |hash, part|
          key_value = part.split('=')
          hash[key_value.first] = key_value.last
          hash
        end
      end
  end
end

Faraday::Response.register_middleware pn_params:
  Ponominalu::ParametersResolver
