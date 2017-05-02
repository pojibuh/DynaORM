require_relative '02_searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.to_s.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions

  attr_reader :class_name, :primary_key, :foreign_key

  def initialize(name, options = {})
    defaults = {
      class_name: name.to_s.capitalize,
      primary_key: :id,
      foreign_key: "#{name.to_s}_id".to_sym
    }

    if options.empty?
      options = options.merge(defaults)
    else
      options = defaults.merge(options)
    end

    @class_name = options[:class_name]
    @primary_key = options[:primary_key]
    @foreign_key = options[:foreign_key]
  end
end

class HasManyOptions < AssocOptions

  attr_reader :class_name, :primary_key, :foreign_key

  def initialize(name, self_class_name, options = {})
    defaults = {
      class_name: name.to_s.capitalize.singularize,
      primary_key: :id,
      foreign_key: "#{self_class_name.underscore}_id".to_sym
    }

    if options.empty?
      options = defaults
    else
      options = defaults.merge(options)
    end

    @class_name = options[:class_name]
    @primary_key = options[:primary_key]
    @foreign_key = options[:foreign_key]
  end
end

module Associatable

  def belongs_to(name, options = {})

    self.assoc_options[name] = BelongsToOptions.new(name, options)

    define_method(name) do
      options = self.class.assoc_options[name]

      foreign_key = self.send(options.foreign_key)
      options.model_class.where(options.primary_key => foreign_key).first
    end
  end

  def has_many(name, options = {})
    self.assoc_options[name] = HasManyOptions.new(name, self.name, options)

    define_method(name) do
      options = self.class.assoc_options[name]

      foreign_key = self.send(options.primary_key)

      options.model_class.where(options.foreign_key => foreign_key)
    end
  end

  def assoc_options
    @assoc_options ||= {}
    @assoc_options
  end
end

class SQLObject
  extend Associatable
end
