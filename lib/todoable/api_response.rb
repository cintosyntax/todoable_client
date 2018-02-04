module Todoable
  class ApiResponse
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def to_hash
      {
        status_code: status_code,
        success: success,
        data: data
      }
    end

    private

    def status_code
      response.status
    end

    def success
      status_code < 400
    end

    def data
      JSON.parse(response.body)
    rescue StandardError
      nil
    end
  end
end
