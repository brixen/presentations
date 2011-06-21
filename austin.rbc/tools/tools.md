!SLIDE bullets incremental

# tools #

* debugger
* profiler
* heap dump
* Agent


!SLIDE

    @@@ ruby
    x = Problem.new
    puts x.big(3) > x.small(3)

    => false

!SLIDE

    @@@ ruby
    class Problem
      def big(a)
        a * 2
      end

      def small(a)
        a ** 2
      end
    end


!SLIDE commandline incremental

    $ rbx -Xdebug problem.rb

    | Breakpoint: Rubinius::Loader#debugger at kernel/loader.rb:523 (53)
    ==== Bytecode between 45 and 56 for line 523 ====
    |    45: push_const_fast :Rubinius, 13
    |    48: find_const 14
    |    50: send_stack :start, 0
    |    53: goto 56
    |    55: push_nil
    |    56: ret

    $ debug> b Problem#big

    * Unable to find class/module: Problem
    | Would you like to defer this breakpoint to later? [y/n] y
    | Deferred breakpoint created.

    $ debug> c

    | Resolved breakpoint for Problem#big
    | Set breakpoint 2: tools/problem.rb:3 (+0)
    | Breakpoint: Problem#big(a) at tools/problem.rb:3 (0)
    | 3:     a * 2

!SLIDE commandline incremental

    $ debug> c

    | Resolved breakpoint for Problem#big
    | Set breakpoint 2: tools/problem.rb:3 (+0)
    | Breakpoint: Problem#big(a) at tools/problem.rb:3 (0)
    | 3:     a * 2

    $ debug> p a
    -> $d0 = 3

    $ debug> p a = 30
    -> $d1 = 30

    $ debug> n
    | Breakpoint: Object#__script__ at tools/problem.rb:12 (62)
    | 12: puts x.big(3) > x.small(3)

    $ debug> c
    true

!SLIDE commandline smaller

    $ rbx -Xprofile -e '10000.times { |x| x * x + x * 2 }'

    Thread 1: total running time: 0.073496367s

      %   cumulative   self                self     total
     time   seconds   seconds      calls  ms/call  ms/call  name
    ------------------------------------------------------------
      70.58    0.05      0.05          1    52.05    52.05  Rubinius::Tooling.disable
      12.43    0.01      0.01      10000     0.00     0.00  Object::__script__<1> {}
       7.24    0.02      0.01          1     5.34    16.74  Integer#times
       3.03    0.00      0.00      20000     0.00     0.00  Fixnum#*
       1.61    0.00      0.00          1     1.19     1.19  Rubinius::AST::Send#bytecode
       1.38    0.00      0.00          1     1.02     2.78  Rubinius::Compiler::Parser#run
       1.07    0.00      0.00          1     0.79     3.58  Rubinius::Compiler.compile_eval
       0.74    0.00      0.00          4     0.14     0.44  Rubinius::Compiler::Stage#run_next
       0.58    0.00      0.00          1     0.42     1.75  Rubinius::Compiler::Generator#run
       0.53    0.02      0.00          1     0.39    20.97  Rubinius::Loader#evals
       0.19    0.05      0.00          1     0.14    52.19  Rubinius::Profiler::Instrumenter#__stop__
       0.18    0.02      0.00          1     0.13    20.58  Kernel#eval
       0.15    0.00      0.00          1     0.11     3.69  Rubinius::Compiler.construct_block
       0.09    0.00      0.00          1     0.06     1.25  Rubinius::AST::EvalExpression::bytecode<906> {}
       0.06    0.00      0.00          1     0.05     1.30  Rubinius::AST::Container#container_bytecode
       0.05    0.05      0.00          1     0.04    52.25  Rubinius::Loader#epilogue
       0.03    0.00      0.00          1     0.02     1.32  Rubinius::AST::EvalExpression#bytecode
       0.01    0.00      0.00          1     0.01     2.79  Rubinius::Compiler#run
       0.01    0.05      0.00          1     0.01    52.21  Object::__script__<4> {}
       0.01    0.02      0.00          1     0.01    16.75  Object::__script__<1> {}
       0.01    0.02      0.00          1     0.01    16.75  Rubinius::BlockEnvironment#call_on_instance
       0.01    0.05      0.00          1     0.01    52.20  Profiler__.stop_profile
       0.01    0.05      0.00          1     0.00    52.19  Rubinius::Profiler::Instrumenter#stop
       0.01    0.05      0.00          1     0.00    52.20  Profiler__.print_profile

    24 methods called a total of 30,025 times

!SLIDE commandline smaller incremental

    $ rbx -r rubinius/analyst -e 'puts Rubinius::Analyst.new.total_memory'

    21.8M

    $ rbx -r rubinius/analyst -e 'puts Rubinius::Analyst.new.itemized_memory'

      Young: 6.0M
     Mature: 10.0M
      Large: 143.3K
       Code: 5.1M
    Symbols: 110.3K

      Total: 21.4M

!SLIDE smaller

    @@@ ruby
    class Analyst
      include Rubinius::Stats::Units

      def initialize
        @agent = Rubinius::Agent.loopback
      end

      MEMORY_BANKS = [:young, :mature, :large, :code, :symbols]

      def total_memory
        total = MEMORY_BANKS.inject(0) do |s, m|
          s + @agent.get("system.memory.#{m}.bytes").last
        end

        auto_bytes total
      end
    end
