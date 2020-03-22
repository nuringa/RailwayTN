module Accessors
  def attr_accessor_with_history(*attributes)
    attributes.each do |attr|
      var = "@#{attr}".to_sym
      var_history = "@#{attr}_history".to_sym
      define_method(attr) { instance_variable_get(var) }
      define_method("#{attr}_history") { instance_variable_get(var_history) }

      define_method("#{attr}=".to_sym) do |value|
        instance_variable_set(var, value)
        instance_variable_set(var_history, []) if instance_variable_get(var_history).nil?
        instance_variable_get("@#{attr}_history").push(value)
      end
    end
  end

  def strong_attr_accessor(attr, attr_class)
    var = "@#{attr}".to_sym
    define_method(attr) { instance_variable_get(var) }
    define_method("#{attr}=".to_sym) do |value|
      begin
        raise(ArgumentError, 'InvalidType') unless value.is_a?(attr_class)

        instance_variable_set(var, value)
      rescue ArgumentError => e
        puts "Ошибка при присвоении значения: #{e.message}"
      end
    end
  end
end
