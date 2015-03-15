require 'minitest_helper'

class TranslatorTest < Minitest::Test
  
  def test_translation_without_service
    SimpleTranslation.config do |config|
      config.service = nil
    end  

    assert_raises(SimpleTranslation::ServiceNotFoundError) do
      SimpleTranslation::Translator.new('To be translated')    
    end
  end

  def test_translation_with_unknown_service
    SimpleTranslation.config do |config|
      config.service = :unknown
    end  

    assert_raises(SimpleTranslation::ServiceNotFoundError) do
      SimpleTranslation::Translator.new('To be translated')    
    end
  end

  def test_translation_without_text
    SimpleTranslation.config do |config|
      config.service = :bing
    end

    assert_raises(SimpleTranslation::TextNotFoundError) do
      SimpleTranslation::Translator.new('')
    end

    assert_raises(SimpleTranslation::TextNotFoundError) do
      SimpleTranslation::Translator.new(nil)
    end
  end

end
