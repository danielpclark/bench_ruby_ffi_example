$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "ffi_example"

require "minitest/autorun"
require 'simplecov'
SimpleCov.start

require 'color_pound_spec_reporter'
Minitest::Reporters.use! [ColorPoundSpecReporter.new]   

