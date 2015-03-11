module SimpleTranslation

  class InvalidCredentialError < StandardError; end
  class TranslateRequestError < StandardError; end

  class Translator
    attr_reader :service

    def initialize(text_to_be_translated)
      @text_to_be_translated = text_to_be_translated
      load_service
    end
    
    private

    def load_service
      case Configuration.service
      when :bing
        @service = BingService.new(@text_to_be_translated)
      end  
    end

  end

  class << self
    
    def config(&block)
      Configuration.configure(&block)
    end

  end

end

require "simple_translation/version"
require "simple_translation/configuration"
require "simple_translation/translation_response"
require "simple_translation/bing_service"
