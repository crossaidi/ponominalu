module Ponominalu
  module API
    # Base part of Ponominalu API endpoint url.
    BASE_URL = 'http://api.cultserv.ru/jtransport'.freeze

    class << self
      # API method call.
      # @param [String] method_name A name of the method.
      # @param [Hash] args Method arguments.
      # @return [Hashie::Mash] Mashed server response.
      def call_method(method_name, args = {}, &block)
        method_name_str = method_name.to_s
        url = create_url(method_name_str)
        args = Helpers.flatten(args)

        response = connection(url).send(Ponominalu.http_verb,
          method_name_str, args).body

        Response.process(response, block)
      end

      # Faraday connection.
      # @param [String] url Connection URL (either full or just prefix).
      # @return [Faraday::Connection] Created connection.
      def connection(url)
        Faraday.new(url, Ponominalu.faraday_options) do |faraday|
          faraday.request  :multipart
          faraday.request  :url_encoded
          faraday.request  :retry, Ponominalu.max_retries

          unless Ponominalu.raw
            faraday.response :mashify
            faraday.response :oj, preserve_raw: true
          end

          faraday.response :pn
          faraday.adapter  Ponominalu.adapter
        end
      end

      private
        # Creates a complete url from prefixes and the method name
        # @param [String] method_name A name of the method.
        # @return [String] url
        def create_url(method_name)
          filename = File.expand_path('../simple_methods.yml', __FILE__)
          simple_methods = YAML.load_file(filename)
          url_prefix = simple_methods.include?(method_name) ? '/simple/' :
            '/partner/'
          BASE_URL + url_prefix
        end
    end
  end
end

