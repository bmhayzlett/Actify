class AttrAccessorObject
  def self.my_attr_accessor(*names)

    names.each do |name|
      define_method("#{name}=") do |var|
        instance_variable_set("@#{name}", var)
      end
    end

    names.each do |name|
      define_method("#{name}") {instance_variable_get("@#{name}")}
    end

  end


end
