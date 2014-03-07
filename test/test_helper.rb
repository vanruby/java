require 'bundler/setup'
require 'minitest/autorun'
require 'java'

# Ensure backward compatibility with Minitest 4
Minitest::Test = MiniTest::Unit::TestCase unless defined?(Minitest::Test)
