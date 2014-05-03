module Ponominalu
  module Helpers
    class << self
      # Flattens enumerable values of user param
      # (for example "exclude")
      # @param [Hash] Hash of unflatten arguments
      # @return [Hash] Result hash
      def flatten(args)
        args.inject({}) do |hash, (k, v)|
          hash[k] = v.respond_to?(:join) ? v.join(',') : v
          hash
        end
      end

      # Converts params string to hash
      # @param [String] Part of the request url with user params
      # @return [Hash] Hash of user params
      def parse_params(params)
        params.split('&').inject({}) do |hash, part|
          key_value = part.split('=')
          hash[key_value.first] = key_value.last
          hash
        end
      end
    end
  end
end