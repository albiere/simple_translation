module SimpleTranslation
  module Client
    
    def translate(from: nil, to: nil)
      response = RequestHandler.post(@service.class.translation_url, translation_params(from, to))
      @service.parse_translation_response(response)
    end

    private

    def translation_params(from, to)
      @service.build_translate_hash(from, to)
    end

  end
end
