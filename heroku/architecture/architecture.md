!SLIDE main_topic

# Architecture #

!SLIDE bullets incremental

# Components #

* virtual machine
* generational GC
* JIT compiler
* Ruby core library

!SLIDE bigger

# Ruby #

!SLIDE bigger

# otherwise C/C++ #

!SLIDE smaller

# MRI #

    @@@ c
    rb_define_method(rb_cArray, "[]", rb_ary_aref, -1);

!SLIDE

# Rubinius #

    @@@ ruby
    class Array
      def []
        Ruby.primitive :array_aref
        raise PrimitiveFailure,
          "Array#[] primitive failed"
      end
    end

!SLIDE

    @@@ cpp
    class Array : public Object {
    private:
      Fixnum* total_; // slot
      Tuple* tuple_;  // slot

    public:
      attr_accessor(total, Fixnum);
      attr_accessor(tuple, Tuple);
    }


!SLIDE

    @@@ cpp
    class Array : public Object {
      // Ruby.primitive :array_aref
      Object* aref(STATE, Fixnum* idx);
    }

