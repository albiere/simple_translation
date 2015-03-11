require 'nokogiri'
require 'json'

module SimpleTranslation
  class BingService

    def initialize(text_to_be_translated)
      @text_to_be_translated = text_to_be_translated
    end
    
    def build_translate_hash(from: nil, to: nil)
      translation_hash(@text_to_be_translated, from, to)
    end

    def build_credential_hash
      credentials_hash
    end

    def parse_credential_response(response)
      raise InvalidCredentialError.new unless response.status == 200 
      JSON.parse(response.body, symbolize_names: true)[:access_token]
    end

    def parse_translation_response(response)
      raise TranslateRequestError.new unless response.status == 200

      document = Nokogiri::XML(response.body)
      text = document.css('string').text

      TranslationResponse.new(text)
    end

    class << self
      
      def translation_url
        'http://api.microsofttranslator.com/V2/Http.svc/Translate' 
      end

      def credential_url
        'https://datamarket.accesscontrol.windows.net/v2/OAuth2-13'
      end

    end

    private

    def translation_hash(text, from, to)
      {
        :appId => '',
        :from => from,
        :to => to,
        :text => text,
        :contentType => 'text/plain'
      }
    end

    def credentials_hash
      {
        client_id: Configuration.bing_client_id,
        client_secret: Configuration.bing_client_secret,
        grant_type: 'client_credentials',
        scope: 'http://api.microsofttranslator.com'
      }
    end

  end
end
