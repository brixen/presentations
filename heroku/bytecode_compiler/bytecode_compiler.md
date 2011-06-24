!SLIDE main_topic

# Bytecode Compiler #

!SLIDE commandline incremental

    $ rbx compile -e 'def m(a, b=1) a + b end' -N m -B

    ================== :m ==================
    Arguments:   1 required, 0 post, 2 total
    Locals:      2: a, b
    Stack size:  4
    Lines to IP: 1: -1..14

    0000:  passed_arg          1
    0002:  goto_if_true        8
    0004:  meta_push_1
    0005:  set_local           1    # b
    0007:  pop
    0008:  push_local          0    # a
    0010:  push_local          1    # b
    0012:  meta_send_op_plus   :+
    0014:  ret
    ----------------------------------------


!SLIDE commandline incremental

    $ rbx compile -e 'def m(a, b=1) a + b end' -B

    ============= :__script__ ==============
    Arguments:   0 required, 0 post, 0 total
    Locals:      0
    Stack size:  5
    Lines to IP: 1: 0..15

    0000:  push_rubinius
    0001:  push_literal    :m
    0003:  push_literal    #<Rubinius::CompiledMethod m file=(snippet)>
    0005:  push_scope
    0006:  push_variables
    0007:  send_stack      :method_visibility, 0
    0010:  send_stack      :add_defn_method, 4
    0013:  pop
    0014:  push_true
    0015:  ret
    ----------------------------------------


!SLIDE

    @@@ ruby
    def self.compile_string(string, file="(eval)", line=1)
      compiler = new :string, :compiled_method

      parser = compiler.parser
      parser.root AST::Script
      parser.default_transforms
      parser.input string, file, line

      compiler.run
    end

