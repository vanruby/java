require 'test_helper'

class JavaTest < Minitest::Test
  def test_new
    time = new Time()
    assert_instance_of Time, time

    time = new Time(2014, 3, 1)
    assert_equal Time.new(2014, 3, 1), time
  end

  def test_void
    assert_correct_type :void, nil
    assert_wrong_type :void, "not void"
  end

  def test_byte
    assert_correct_type :byte, 127
    assert_correct_type :byte, -128
    assert_wrong_type :byte, 128
    assert_wrong_type :byte, -129
    assert_wrong_type :byte, "not byte"
    assert_wrong_type :byte, nil
  end

  def test_short
    assert_correct_type :short, 32767
    assert_correct_type :short, -32768
    assert_wrong_type :short, 32768
    assert_wrong_type :short, -32769
    assert_wrong_type :short, "not short"
    assert_wrong_type :short, nil
  end

  def test_int
    assert_correct_type :int, 2147483647
    assert_correct_type :int, -2147483648
    assert_wrong_type :int, 2147483648
    assert_wrong_type :int, -2147483649
    assert_wrong_type :int, "not int"
    assert_wrong_type :int, nil
  end

  def test_long
    assert_correct_type :long, 9223372036854775807
    assert_correct_type :long, -9223372036854775808
    assert_wrong_type :long, 9223372036854775808
    assert_wrong_type :long, -9223372036854775809
    assert_wrong_type :long, "not long"
    assert_wrong_type :long, nil
  end

  def test_float
    assert_correct_type :float, 1.0
    assert_correct_type :float, Math::PI, "Math::PI"
    assert_wrong_type :float, 1
    assert_wrong_type :float, "not float"
    assert_wrong_type :float, nil
  end

  def test_double
    assert_correct_type :double, 1.0
    assert_correct_type :double, Math::PI, "Math::PI"
    assert_wrong_type :double, 1
    assert_wrong_type :double, "not double"
    assert_wrong_type :double, nil
  end

  def test_bool
    assert_correct_type :bool, true
    assert_correct_type :bool, false
    assert_wrong_type :bool, "not bool"
    assert_wrong_type :bool, nil
  end

  def test_char
    assert_correct_type :char, 'a'
    assert_correct_type :char, '☃'
    assert_correct_type :char, '☃', '"\u2603"'
    assert_wrong_type :char, 1
    assert_wrong_type :char, "not char"
    assert_wrong_type :char, nil
  end

  def test_user_type
    Object.const_set 'UserType', Class.new

    user_type = new UserType()
    Type.define_new(:UserType, UserType)

    assert_correct_type :UserType, user_type, "ObjectSpace._id2ref(#{user_type.__id__})"
    assert_wrong_type :UserType, 1
    assert_wrong_type :UserType, "not UserType"
    assert_wrong_type :UserType, nil
  end

  private
    def define_test_method(type, val, raw_val = nil)
      klass = Class.new.class_eval <<-RUBY_CODE
        public #{type} def call
          #{raw_val ? raw_val : val.inspect}
        end
      RUBY_CODE

      klass.new
    end

    def assert_correct_type(type, val, raw_val = nil)
      assert_equal val, define_test_method(type, val, raw_val).call
    end

    def assert_wrong_type(type, val, raw_val = nil)
      assert_raises(TypeError) { define_test_method(type, val, raw_val).call }
    end
end
