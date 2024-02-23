module PlausibleApi
  class ApiBase < Utils
    def request_class
      # Net::HTTP::Post
      raise NotImplementedError
    end

    def request_path
      # "/api/event"
      raise NotImplementedError
    end

    def request_auth?
      true
    end

    def request_body
      nil
    end

    def request_body?
      present?(request_body)
    end

    def request_headers
      {"content-type" => "application/json"}
    end

    def parse_response(body)
      raise NotImplementedError
    end

    def errors
      raise NotImplementedError
    end

    def valid?
      errors.empty?
    end
  end
end
