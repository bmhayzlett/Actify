require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.constantize
  end

  def table_name
    self.class_name.downcase + "s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    options.each do |key, value|
      self.send("#{key}=", value)
    end
    # debugger
    self.primary_key = :id unless self.primary_key
    self.foreign_key = (name.to_s + "_id").to_sym unless self.foreign_key
    self.class_name = name.to_s.camelcase unless self.class_name

  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    options.each do |key, value|
      self.send("#{key}=", value)
    end

    self.primary_key = :id unless self.primary_key
    self.foreign_key = (self_class_name.to_s.downcase + "_id").to_sym unless self.foreign_key
    self.class_name = name.to_s.singularize.camelcase unless self.class_name

  end
end

module Associatable

  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)

    define_method(name) do
      options = self.class.assoc_options[name]

      key_value = self.send(options.foreign_key)
      options.model_class.where(options.primary_key => key_value).first
    end
  end

  def has_many(name, options = {})
    define_method(name) do
      @options = HasManyOptions.new(name, self.class, options)
      key_value = self.send(@options.primary_key)
      @options.model_class.where(@options.foreign_key => key_value)
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
  
end

class SQLObject
  self.extend(Associatable)
end
