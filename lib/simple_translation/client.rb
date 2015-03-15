module SimpleTranslation
  module Client
    
    def translate(from: nil, to: nil)
      process_credentials if @service.respond_to?(:parse_credential_response)

      response = RequestHandler.post(@service.class.translation_url, translation_params(from, to))
      @service.parse_translation_response(response)
    end

    private

    def process_credentials
        response = RequestHandler.post(@service.class.credential_url, credential_params)
        @service.parse_credential_response(response)
    end

    def translation_params(from, to)
      @service.build_translate_hash(from, to)
    end

    def credential_params
      @service.build_credential_hash
    end

  end
end
