require "java/version"

module Java
  BYTE  = -1<<7...1<<7
  SHORT = -1<<15...1<<15
  INT   = -1<<31...1<<31
  LONG  = -1<<63...1<<63

  def self.assert_return_type(meth, type, type_klass = NilClass, rtn, &condition)
    if (type == :void || rtn != nil) && (type_klass === rtn) && (!condition || condition.(rtn))
      rtn
    else
      raise TypeError, "Expected #{meth} to return #{type} but got #{rtn.inspect} instead"
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

    def define_typed_method(meth, type, type_klass, &condition)
      __java__.send(:define_method, meth) do |*args, &block|
        ::Java.assert_return_type(meth, type, type_klass, super(*args, &block), &condition)
      end
    end
end

module Boolean; end

TrueClass.send(:include, Boolean)
FalseClass.send(:include, Boolean)

module Type
  def self.define_new(type, type_klass, &condition)
    Module.class_eval do
      define_method(type) do |meth|
        define_typed_method(meth, type, type_klass, &condition)
      end
      private type
    end
  end
end

Type.define_new(:void, NilClass)
Type.define_new(:byte, Integer) { |rtn| ::Java::BYTE === rtn }
Type.define_new(:short, Integer) { |rtn| ::Java::SHORT === rtn }
Type.define_new(:int, Integer) { |rtn| ::Java::INT === rtn }
Type.define_new(:long, Integer) { |rtn| ::Java::LONG === rtn }
Type.define_new(:float, Float)
Type.define_new(:double, Float)
Type.define_new(:bool, Boolean)
Type.define_new(:char, String) { |rtn| rtn.length == 1 }
