class Decorator < BasicObject
   undef_method :==

   def initialize (target)
      @target = target
   end

   def method_missing (name, *args, &block)
      @target.send(name, *args, &block)
   end

   def send (symbol, *args)
      __send__(symbol, *args)
   end
   
end
