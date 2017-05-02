class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      define_method(name) do
        instance_variable_get("@#{name}".to_sym)
      end
      define_method("#{name}=") do |other_thing|
        instance_variable_set("@#{name}".to_sym, other_thing)
      end
    end
  end
end