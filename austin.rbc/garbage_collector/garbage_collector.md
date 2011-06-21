!SLIDE bullets incremental

# garbage collector #

* generational
* fast allocation
* fast collection
* steady state

!SLIDE

    @@@ ruby
    class Link
      attr_accessor :left, :right

      def initialize(left=nil, right=nil)
        @left = left
        @right = right
      end
    end

!SLIDE commandline incremental

    $ rbx -rlink -e 'p Rubinius.memory_size(Link.new)'

    40

    $ rbx -Xgc.autopack=false -rlink -e '...'

    152

    $ rbx -rlink -e 'p Rubinius.memory_size(Hash.new)'

    80

    $ rbx -Xgc.autopack=false -rlink -e '...'

    152

!SLIDE bullets incremental

# garbage collector #

* slabs - concurrency
* pluggable

