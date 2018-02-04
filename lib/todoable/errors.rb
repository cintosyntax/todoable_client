module Todoable
  class Errors
    class InvalidCredentials < StandardError
    end

    class UnexpectedResponse < StandardError
      def initialize(context, response)
        msg = "unexpected response retrieved from API. Got #{response.status} "\
              "when #{context} was called."
        super(msg)
      end
    end
  end
end
