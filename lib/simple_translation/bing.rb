require 'nokogiri'
require 'json'

module SimpleTranslation
  class Bing
    
    CREDENTIAL_URL = 'https://datamarket.accesscontrol.windows.net/v2/OAuth2-13'
    TRANSLATE_URL = 'http://api.microsofttranslator.com/V2/Http.svc/Translate'

    def initialize(options)
      @options = options
    end

    def translate(text, options)
      options = @options.merge(options).merge({ text: text })

      response = RequestHandler.post(TRANSLATE_URL, translate_params(options))
      response = BingTranslationResponse.new(response)
      response.create_response
    end

    def request_token
      response = RequestHandler.post(CREDENTIAL_URL, credential_params)
      BingCredentialResponse.new(response).access_token
    end

    private

    def translate_params(options)
      {
        'appId' => '',
        'from' => options[:from],
        'to' => options[:to],
        'text' => options[:text],
        'contentType' => 'text/plain',
        'authorization' => request_token
      }
    end

    def credential_params
      {
        'client_id' => @options[:client_id],
        'client_secret' => @options[:client_secret],
        'grant_type' => 'client_credentials',
        'scope' => 'http://api.microsofttranslator.com'
      }
    end

    protected

    class BingTranslationResponse
      
      def initialize(response)
        raise TranslateRequestError unless response.status == 200

        @body = response.body
        @status = response.status
        @document = Nokogiri::XML(response.body)
      end

      def create_response
        TranslationResponse.new(string_translated)
      end
      
      private

      def string_translated
        @document.css('string').text
      end

    end

    class BingCredentialResponse

      def initialize(response)
        raise InvalidCredentialError unless response.status == 200
        @json = JSON.parse(response.body, symbolize_names: true)
      end

      def access_token
        @json[:access_token]
      end

    end

  end
end
