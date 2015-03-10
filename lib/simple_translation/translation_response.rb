module SimpleTranslation
  class TranslationResponse
    attr_reader :text

    def initialize(text)
      @text = text
    end
  end
end
