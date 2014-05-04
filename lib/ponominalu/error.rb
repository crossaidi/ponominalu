module Ponominalu
  # An exception raised by `Ponominalu::Response` when given a response with an error.
  class Error < StandardError
    # An error code.
    # @return [Fixnum]
    attr_reader :error_code
    # An exception is initialized by the data from response mash.
    # @param [Hash] data Error data.
    def initialize(data)
      @error_code   = data.code
      @error_msg    = data.message
      @method_name  = data.method_name
      @session      = data.session
      @params       = data.params
    end

    # A full description of the error.
    # @return [String]
    def message
      message = "Ponominalu returned an error #{@error_code}: '#{@error_msg}'"\
                " after calling method '#{@method_name}'"

      if (@params.empty?)
        message << " without parameters."
      else
        message << " with parameters #{@params.inspect}."
      end
      message << " App session is '#{@session}'."
      message
    end
  end
end
