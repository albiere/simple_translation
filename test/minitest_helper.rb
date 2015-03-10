$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simple_translation'
require 'minitest/autorun'
require 'mocha/mini_test'
require 'minitest/reporters'
require 'faraday'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
