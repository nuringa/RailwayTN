module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :validations

    def validate(attr, type, param = nil)
      @validations ||= []
      @validations << { attr: attr, type: type, param: param }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |validation|
        validation_method = "validate_#{validation[:type]}".to_sym
        send(validation_method, validation[:attr], validation[:param])
      end
      true
    end

    def valid?
      validate!
    rescue RuntimeError => e
      puts "Ошибка в валидациях: #{e.message}"
      false
    end

    private

    def validate_presence(attr, _params)
      value = instance_variable_get("@#{attr}")
      raise "#{attr} не может быть пустым" if value.nil? || value.empty?
    end

    def validate_format(attr, format)
      value = instance_variable_get("@#{attr}")
      raise "Неверный формат #{attr}" unless value&.match?(format)
    end

    def validate_type(attr, attr_class)
      value = instance_variable_get("@#{attr}")

      raise "#{value} не является объектом класса #{attr_class}" unless value.is_a?(attr_class)
    end

    def validate_uniqness(attr1, attr2)
      value1 = instance_variable_get("@#{attr1}")
      value2 = instance_variable_get("@#{attr2}")
      raise 'Значения не могут совпадать' if value1 == value2
    end
  end
end
