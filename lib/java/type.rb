class Type
  @@types = []

  attr_accessor :sym, :klass, :condition

  private_class_method :new

  def initialize(sym, klass, &condition)
    @sym, @klass, @condition = sym, klass, condition
    @@types << self
  end

  class << self
    def define_new(sym, klass, &condition)
      Module.class_eval do
        define_method(sym) do |meth|
          define_typed_method(meth, Type.find_or_create(sym, klass, &condition))
        end
        private sym
      end
    end

    def find(sym)
      @@types.find { |type| type.sym == sym }
    end

    def find_or_create(sym, klass, &condition)
      find(sym) || new(sym, klass, &condition)
    end
  end
end
