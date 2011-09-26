!SLIDE main_topic bullets incremental

# Tools #

* debugger
* profiler
* Agent
* memory analysis

!SLIDE sub_topic

# Debugger #

!SLIDE

    @@@ ruby
    x = Problem.new
    puts x.big(3) > x.small(3)

    => false

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

!SLIDE sub_topic

# Profiler #

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

!SLIDE sub_topic

# Agent #

!SLIDE commandline

    $ rbx -Xagent.start
    irb(main):001:0>

!SLIDE commandline

    $ rbx console
    VM: rbx -Xagent.start
    Connecting to VM on port 56488
    Connected to localhost:56488, host type: x86_64-apple-darwin10.7.0
    console>

!SLIDE commandline

    console> get system
    var system = [
      "name",
      "backtrace",
      "threads",
      "gc",
      "memory",
      "pid",
      "jit",
    ]

!SLIDE commandline

    console> get system.pid
    var system.pid = [
      69118,
    ]
    console> get system.threads
    var system.threads = [
      "count",
      "backtrace",
    ]
    console> get system.threads.count
    var system.threads.count = 2

!SLIDE commandline

    console> get system.memory.young.bytes
    var system.memory.young.bytes = 6291456
    console> get system.gc
    var system.gc = [
      "full",
      "young",
    ]
    console> get system.gc.full
    var system.gc.full = [
      "last_wallclock",
      "count",
      "total_wallclock",
    ]
    console> get system.gc.full.count
    var system.gc.full.count = 0
    console> get system.gc.young.count
    var system.gc.young.count = 5


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

!SLIDE sub_topic

# Memory Analysis #

!SLIDE smaller

    @@@ Ruby
    require "rubinius/agent"

    agent = Rubinius::Agent.loopback

    agent.request :set_config, "system.memory.dump", "before.dump"

    array = (0..10).map { |i| "x" * rand(i) }
    p array

    agent.request :set_config, "system.memory.dump", "after.dump"

!SLIDE commandline small

    $ rbx memory_analysis.rb

    Heap dumped to before.dump
    ["", "", "x", "", "x", "xxxx", "", "xxxxxx", "xxxxxxx", "", "xxxxxxx"]
    Heap dumped to after.dump


!SLIDE commandline incremental small

    $ rbx -I /source/heap_dump/lib/ /source/heap_dump/bin/histo.rb before.dump

     20738                Rubinius::Tuple 3763200
      5820                         Object 279312
      5001  Rubinius::MethodTable::Bucket 280056
      4388       Rubinius::CompiledMethod 877600
      4388  Rubinius::InstructionSequence 140416
      3269                         String 209216
      3166            Rubinius::CharArray 166864
      1815  Rubinius::LookupTable::Bucket 87120
      1130          Rubinius::LookupTable 54240
      1100     Rubinius::GlobalCacheEntry 52800
      1047          Rubinius::MethodTable 50256
      1001                          Class 100384
       835          Rubinius::StaticScope 40080
       676       Rubinius::AccessVariable 54080
       456                          Array 25536
       141                    Hash::Entry 7896
       123   Rubinius::CompactLookupTable 15744
       105       Rubinius::NativeFunction 10920
       102 Rubinius::InstructionSet::OpCode 13872
        46                         Module 2944
        46                          Float 1472
        46       Rubinius::IncludedModule 3312
        39 Rubinius::CompiledMethod::Script 2808
        22                           Hash 1760


!SLIDE commandline incremental small

    $ rbx -I /source/../lib /source/.../histo.rb before.dump after.dump

        54                         Object 2592
        11                         String 704
        11            Rubinius::CharArray 440
         8     Rubinius::GlobalCacheEntry 384
         2   Rubinius::CompactLookupTable 256
         2            Rubinius::ByteArray 2624
         2                Rubinius::Tuple 184
         1           Rubinius::Randomizer 48
         1                         Bignum 56
         1        Rubinius::VariableScope 104
         1                          Array 56

