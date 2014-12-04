module JavaClass
  def method_missing(meth, *args, &block)
    if block
      eval <<-RUBY_CODE
        define_method(#{meth}) do |#{args.join(',')}|
        #{block.call}
      end
      RUBY_CODE
    else
      meth
    end
  end
end
