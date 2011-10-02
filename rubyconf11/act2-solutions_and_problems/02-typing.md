!SLIDE single-point-intro

# Optional Typing

!SLIDE single-point

# Ruby is about _behavior_

!SLIDE single-point

# _You are what you do_

!SLIDE single-point

# ducktyping

!SLIDE single-point

# Classes

# organize code

!SLIDE single-point

# Classes

# support

# _encapsulation_

!SLIDE bullets description-list

# Three Pillars of OO

* Encapsulation
* Polymorphism
* Inheritance

!SLIDE single-point-intro

# _Hidden_ Typing

_typing requirements that are concealed from Ruby code_

!SLIDE single-point

# Not in Ruby

!SLIDE single-point

# Undefined

# Or

# Not documented

!SLIDE single-point

# Ruby cannot participate

!SLIDE smaller

    @@@ C
    VALUE
    rb_to_float(VALUE val)
    {
      if (TYPE(val) == T_FLOAT) return val;
      if (!rb_obj_is_kind_of(val, rb_cNumeric)) {
        rb_raise(rb_eTypeError, "can't convert %s into Float",
        NIL_P(val) ? "nil" :
        val == Qtrue ? "true" :
        val == Qfalse ? "false" :
        rb_obj_classname(val));
      }
      return rb_convert_type(val, T_FLOAT, "Float", "to_f");
    }


!SLIDE small

    @@@ Ruby
    def wrong(a, b)
      unless a.kind_of? Numeric
        raise "must be an instance of Numeric"
      end
      # ...
    end

!SLIDE single-point

# Ruby is dictating the _structure_ of programs

!SLIDE single-point

# brittle

# _unnecessary_

# wrong

!SLIDE single-point

# Types tell you what you _cannot_ do

!SLIDE single-point

# Like all walls, people try to _defeat_ them

!SLIDE single-point

# _complexity_

!SLIDE single-point

# _pain_
