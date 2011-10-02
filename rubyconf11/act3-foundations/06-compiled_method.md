!SLIDE single-point-intro

# What is Ruby?

!SLIDE single-point

# Everything is an object

!SLIDE compiled-code

    @@@ ruby
    class A
      a = 1
    end

    module M
      b = 2
    end

!SLIDE compiled-code

    @@@ ruby
    def m(a)
      a + b
    end

    m { |x| x * 1 }

!SLIDE compiled-code

    @@@ ruby
    # ruby_script.rb
    puts "hello"

!SLIDE commandline

    $ rbx
    irb(main):001:0> def m(a, b)
    irb(main):002:1> a + b
    irb(main):003:1> end
    => #<Rubinius::CompiledMethod m file=(irb)>

!SLIDE commandline

    $ rbx compile -e 'puts 1' -B

    ============= :__script__ ==============
    Arguments:   0 required, 0 post, 0 total
    Arity:       0
    Locals:      0
    Stack size:  2
    Lines to IP: 1: 0..8

    0000:  push_self                  
    0001:  meta_push_1                
    0002:  allow_private              
    0003:  send_stack                 :puts, 1
    0006:  pop                        
    0007:  push_true                  
    0008:  ret                        
    ----------------------------------------

!SLIDE commandline smaller

    $ rbx compile -e 'class A; def m; end; end' -B -N __script__

    ============= :__script__ ==============
    Arguments:   0 required, 0 post, 0 total
    Arity:       0
    Locals:      0
    Stack size:  6
    Lines to IP: 1: 0..28

    0000:  push_rubinius              
    0001:  push_literal               :A
    0003:  push_nil                   
    0004:  push_scope                 
    0005:  send_stack                 :open_class, 3
    0008:  dup_top                    
    0009:  push_rubinius              
    0010:  swap_stack                 
    0011:  push_literal               :__class_init__
    0013:  swap_stack                 
    0014:  push_literal               #<Rubinius::CompiledMethod A file=(snippet)>
    0016:  swap_stack                 
    0017:  push_scope                 
    0018:  swap_stack                 
    0019:  send_stack                 :attach_method, 4
    0022:  pop                        
    0023:  send_stack                 :__class_init__, 0
    0026:  pop                        
    0027:  push_true                  
    0028:  ret                        
    ----------------------------------------

!SLIDE commandline small

    $ rbx compile -e 'class A; def m; end; end' -B -N A

    ================== :A ==================
    Arguments:   0 required, 0 post, 0 total
    Arity:       0
    Locals:      0
    Stack size:  5
    Lines to IP: 1: 2..15

    0000:  push_self                  
    0001:  add_scope                  
    0002:  push_rubinius              
    0003:  push_literal               :m
    0005:  push_literal               #<Rubinius::CompiledMethod m file=(snippet)>
    0007:  push_scope                 
    0008:  push_variables             
    0009:  send_stack                 :method_visibility, 0
    0012:  send_stack                 :add_defn_method, 4
    0015:  ret                        
    ----------------------------------------


!SLIDE single-point bigger

# Everything is a _CompiledMethod_

!SLIDE single-point

# Rubinius uses Ruby to build a consistent system

