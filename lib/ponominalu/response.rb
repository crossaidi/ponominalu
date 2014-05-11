module Ponominalu
  module Response
    class << self
      # The main method result processing.
      # @param [Hashie::Mash] response The server response in mash format.
      # @param [Proc] block A block passed to the API method.
      # @return [Array, Hashie::Mash] The processed result.
      # @raise [Ponominalu::Error] raised when Ponominalu returns
      # an error response.
      def process(response, block)
        result = get_result(response)
        result = Oj.dump(result) if Ponominalu.raw_json

        if result.respond_to?(:each)
          # enumerable result receives :map with a block when called
          # with a block or is returned untouched otherwise
          block.nil? ? result : result.map(&block)
        else
          # non-enumerable result is yielded if block_given?)
          block.nil? ? result : block.call(result)
        end
      end

    private
      def get_result(response)
        # an empty array is returned if error code is 0 (not found)
        # and empty_strict option is false
        if response.code.zero? && !Ponominalu.empty_strict
          []
        else
          # if wrap_response option is true response is returned
          # as element of response wrapper with api status code
          # and params
          Ponominalu.wrap_response ? response : response.message
        end
      end
    end
  end
end