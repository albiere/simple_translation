require 'minitest_helper'

class TranslatorTest < Minitest::Test
  include Helpers::FakeRequest
  include Helpers::Fixtures
  
  def setup
    SimpleTranslation.config do |config|
      config.service = :bing
      config.bing_client_id = 'client_id'
      config.bing_client_secret = 'client_secret'
    end

    @url = 'http://api.microsofttranslator.com/V2/Http.svc/Translate'
    @response_en_pt = load_fixture('bing_response_en_pt.xml')
    @response_pt_en = load_fixture('bing_response_pt_en.xml')
  end

  def test_translate_from_en_to_pt
    fake_request(@url, @response_en_pt)

    translator = SimpleTranslation::Translator.new('translation')      
    response = translator.translate(from: 'en', to: 'pt')

    assert_kind_of SimpleTranslation::TranslationResponse, response
    assert_equal 'traducao', response.text
  end

  def test_translate_from_pt_to_en
    fake_request(@url, @response_pt_en)

    translator = SimpleTranslation::Translator.new('traducao')      
    response = translator.translate(from: 'pt', to: 'en')

    assert_kind_of SimpleTranslation::TranslationResponse, response
    assert_equal 'translation', response.text
  end

end
