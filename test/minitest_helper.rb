$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simple_translation'
require 'minitest/autorun'
require 'mocha/mini_test'
require 'minitest/reporters'
require 'webmock/minitest'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

module Helpers
  module Fixtures

    def load_fixture(path)
      File.read(File.join(File.dirname(__FILE__), 'fixtures', path))
    end

  end

  module FakeRequest

    def fake_request(url, response, params = {})
      stub_request(:post, url).with(body: params).to_return(body: response, status: 200, headers: {}) 
    end

  end

  module TestClasses
    
    class TestService
      def initialize(text_to_be_translated)
        @text_to_be_translate = text_to_be_translated
      end

      def build_translate_hash(from, to)
        {}
      end

      def parse_translation_response(response)
        nil
      end

      class << self
        def translation_url
          "http://testurl.com"
        end
      end
        
    end

  end
end
