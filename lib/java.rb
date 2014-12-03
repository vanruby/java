require "java/version"
require "java/type"

module Java
  BYTE  = -1<<7...1<<7
  SHORT = -1<<15...1<<15
  INT   = -1<<31...1<<31
  LONG  = -1<<63...1<<63

  class << self
    def assert_return_type(meth, type, rtn)
      if type.match?(rtn)
        rtn
      else
        raise TypeError, "Expected #{meth} to return #{type.sym} but got #{rtn.inspect} instead"
      end
    end

    def assert_args_type(meth, typed_args)
      if unmatched_arg = typed_args.find { |typed_arg| !Type.find(typed_arg.keys.first).match?(typed_arg.values.first) }
        raise ArgumentError, "Wrong type of argument, type of #{unmatched_arg.values.first} should be #{unmatched_arg.keys.first}"
      end
    end
  end
end

module Kernel
  def new(klass)
    if Array === klass
      klass[0].send(:new, *klass[1], &klass[2])
    else
      klass
    end
  end

  def method_missing(meth, *args, &block)
    [Object.const_get(meth), args, block]
  rescue NameError
    super
  end
end

class Module
  private
    def __java__
      prepend (@__java__ = Module.new) unless @__java__
      @__java__
    end

    def define_typed_method(meth, type)
      __java__.send(:define_method, meth) do |*args, &block|

        typed_args = args.select do |arg|
          arg.is_a?(Hash) && Type.types.map(&:sym).include?(arg.keys.first)
        end

        ::Java.assert_args_type(meth, typed_args) unless typed_args.empty?
        ::Java.assert_return_type(meth, type, super(*args, &block))
      end
    end
end

module Boolean; end

TrueClass.send(:include, Boolean)
FalseClass.send(:include, Boolean)

Type.define_new(:void, NilClass)
Type.define_new(:byte, Integer) { |rtn| ::Java::BYTE === rtn }
Type.define_new(:short, Integer) { |rtn| ::Java::SHORT === rtn }
Type.define_new(:int, Integer) { |rtn| ::Java::INT === rtn }
Type.define_new(:long, Integer) { |rtn| ::Java::LONG === rtn }
Type.define_new(:float, Float)
Type.define_new(:double, Float)
Type.define_new(:bool, Boolean)
Type.define_new(:char, String) { |rtn| rtn.length == 1 }
