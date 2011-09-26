!SLIDE main_topic

# Virtual Machine #

!SLIDE bullets incremental

* stack machine
* custom
* Ruby

!SLIDE smaller

    @@@ cpp
    instruction send_method(literal) [ receiver -- value ] => send
      flush_ip();
      Object* recv = stack_top();
      InlineCache* cache = reinterpret_cast<InlineCache*>(literal);

      SET_ALLOW_PRIVATE(false);

      Arguments args(cache->name, recv, Qnil, 0, 0);
      Object* ret = cache->execute(state, call_frame, args);

      (void)stack_pop();

      CHECK_AND_PUSH(ret);
    end

!SLIDE smaller

    @@@ cpp
    class OneArgument {
    public:
      static bool call(STATE, VMMethod* vmm, StackVariables* scope,
                       Arguments& args)
      {
        if(args.total() != 1) return false;
        scope->set_local(0, args.get_argument(0));
        return true;
      }
    };

