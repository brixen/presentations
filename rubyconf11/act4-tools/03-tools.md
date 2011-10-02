!SLIDE single-point

# CompiledMethod
# database

!SLIDE single-point

# Class browser

!SLIDE single-point

# Coverage and profiling

!SLIDE single-point

# Bytecode instrumentation

!SLIDE commandline

    $ rbx
    irb(main):001:0> class F
    irb(main):002:1> dynamic_method :m do |g|
    irb(main):003:2* g.push :self
    irb(main):004:2> g.push_literal g.name
    irb(main):005:2> g.send :p, 1, true
    irb(main):006:2> g.ret
    irb(main):007:2> end
    irb(main):008:1> end
    => #<Rubinius::CompiledMethod m file=dynamic>
    irb(main):009:0> F.new.m
    :m
    => nil


!SLIDE single-point

# AST transformation

!SLIDE single-point

# Debugging

!SLIDE single-point

# Documentation

!SLIDE bullets incremental description-list

# Analysis

* variables used before set
* unused variables
* misnamed methods
* code quality

!SLIDE single-point

# Custom tools
