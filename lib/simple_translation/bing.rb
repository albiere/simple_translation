require 'nokogiri'
require 'json'

module SimpleTranslation
  class Bing
    
    CREDENTIAL_URL = 'https://datamarket.accesscontrol.windows.net/v2/OAuth2-13'
    TRANSLATE_URL = 'http://api.microsofttranslator.com/V2/Http.svc/Translate'

    def initialize(options)
      @options = options
    end

    def translate
      response = TranslationRequest.post(TRANSLATE_URL, translate_params(request_token))
      raise TranslateRequestError unless response.status == 200

      document = Nokogiri::XML(response.body)
      text = document.css('string').text

      TranslationResponse.new(text)
    end

    def request_token
      response = TranslationRequest.post(CREDENTIAL_URL, credential_params)
      raise InvalidCredentialError unless response.status == 200

      json = JSON.parse(response.body, symbolize_names: true)
      json[:access_token]
    end

    private

    def translate_params(token)
      {
        'appId' => '',
        'from' => @options[:from],
        'to' => @options[:to],
        'text' => @options[:text],
        'contentType' => 'text/plain',
        'authorization' => token
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

  end
end
