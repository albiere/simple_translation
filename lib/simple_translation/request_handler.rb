require 'faraday'

module SimpleTranslation
  class RequestHandler
    
    def self.post(url, params)
      response = Faraday.post(url, params) 
      ConnectionResponse.new(response)
    end

    def self.get(url, params)
      response = Faraday.get(url, params)
      ConnectionResponse.new(response)
    end

  end

  class ConnectionResponse
    attr_reader :body, :status
    
    def initialize(response)
      @body = response.body
      @status = response.status 
    end

  end
end
