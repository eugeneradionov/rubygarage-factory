# Factory is an alias for Struct
class Factory
  def self.new(*args, &block)
    Class.new do
      attr_accessor(*args)

      define_method :initialize do |*arguments|
        args.zip(arguments).each do |method, value|
          unless method.is_a? Symbol
            raise NameError, "identifier #{method} must be constant"
          end
          send("#{method}=", value)
        end

        def [](key)
          key.is_a?(Integer) ? instance_variable_get(instance_variables[key]) : send(key.to_sym)
        end
      end

      class_eval(&block) if block_given?
    end
  end
end
