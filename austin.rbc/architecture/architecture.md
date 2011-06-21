!SLIDE

# architecture #

!SLIDE

# Ruby Ruby Ruby #

!SLIDE

# otherwise C/C++ #

!SLIDE

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

