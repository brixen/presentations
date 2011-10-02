!SLIDE single-point-intro

# Tools

!SLIDE single-point

# Rubinius implements Ruby differently

!SLIDE single-point

# Rubinius uses _Ruby_

!SLIDE single-point

# Consistent system

!SLIDE single-point

# Trees & Leaves

!SLIDE single-point

# How does Rubinius use Ruby?

!SLIDE single-point

# homoiconic

!SLIDE single-point

# _homo-_ same

!SLIDE single-point

# _icon-_ symbol

!SLIDE commandline

    $ rbx
    airb(main):001:0> ast = "a = 1".to_ast
    => #<Rubinius::AST::LocalVariableAssignment:0xf30 @value=#<Rubinius::AST::FixnumLiteral:0xf34 @value=1 @line=1> @line=1 @name=:a @variable=nil>
    irb(main):002:0> ast.class
    => Rubinius::AST::LocalVariableAssignment

!SLIDE commandline

    $ irb(main):003:0> ast.ascii_graph
    LocalVariableAssignment
      @line: 1
      @name: :a
      @variable: nil
      @value: \
        FixnumLiteral
          @value: 1
          @line: 1
    => [["@value", #<Rubinius::AST::FixnumLiteral:0xf34 @value=1 @line=1>]]

!SLIDE commandline

    $ irb(main):004:0> ast.to_sexp
    => [:lasgn, :a, [:lit, 1]]

!SLIDE commandline
    $ irb(main):005:0> "a = 1".to_sexp
    => [:lasgn, :a, [:lit, 1]]

