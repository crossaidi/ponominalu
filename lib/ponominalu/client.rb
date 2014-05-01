module Ponominalu
  class Client
    def method_missing(method, *args)
      API.call_method(method, *args)
    end
  end
end
