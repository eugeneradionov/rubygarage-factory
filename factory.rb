# Factory is an alias for Struct
class Factory
  def self.new(*args, &block)
    Class.new do
      attr_accessor(*args)

      define_method :initialize do |*arguments|
        @arguments = arguments
        args.zip(@arguments).each { |method, value| send("#{method}=", value) }

        def [](key)
          key.is_a?(Integer) ? @arguments[key] : send(key.to_sym)
        end
      end

      class_eval(&block) if block_given?
    end
  end
end
