Java™
=====

The caffeine boost you need for your late-night coding sprints.

Install
-------

`gem install java` or add `gem 'java'` to your Gemfile.

Usage
-----

Currently, the following keywords are supported: `new`, `void`, `byte`, `short`,
`int`, `long`, `float`, `double`, `bool`, `char`.

```ruby
require 'java'

class MyClass
  public def initialize(name)
    @name = name
  end

  public void def main()
    puts "This is the main method from #{@name}"
    return nil
  end

  public int def returns_int()
    1
  end

  public int def not_int()
    'not int'
  end

  public byte def returns_byte()
    1
  end

  public byte def not_byte()
    128
  end

  private bool def this_is_private()
    true
  end
end

# >> obj = new MyClass("my class")
# => #<MyClass:0x000001018333d8 @name="my class">
# >> obj.main()
# This is the main method from my class
# => nil
# >> obj.returns_int()
# => 1
# >> obj.not_int()
# TypeError: Expected not_int to return int but got "not int" instead
# >> obj.returns_byte()
# => 1
# >> obj.not_byte()
# TypeError: Expected not_byte to return byte but got 128 instead
```

Production Ready?
-----------------

It has [tests](https://github.com/vanruby/java/tree/master/test), if that's what
you are asking.

Future Work
-----------

- Bug: typed `private` and `protected` methods doesn't work
- Bug: `Kernel` defines `Array`, `Complex`, `Float`, `Hash`, `Integer`,
  `Rational` and `String` which breaks `new String()` etc
- Support more keywords: `static`, `final`, etc


Credits
-------

Java™ is a registered trademark of Oracle and/or its affiliates.

[@tenderlove](https://github.com/tenderlove) and [@jeremy](https://github.com/jeremy)
first brought this to my attention. [@amatsuda](https://github.com/amatsuda)
also has a [similar gist](https://gist.github.com/amatsuda/6237320).
