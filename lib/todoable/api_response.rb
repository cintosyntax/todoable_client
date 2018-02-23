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
        data: mmmm
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
      body = JSON.parse(response.body)
      if status_code == 422
        { errors: body }.stringify_keys
      else
        body
      end
    rescue StandardError
      nil
    end
  end
end
