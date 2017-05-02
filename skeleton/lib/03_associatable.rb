require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions

  attr_reader :class_name, :primary_key, :foreign_key

  def initialize(name, options = {})
    defaults = {
      class_name: name.capitalize,
      primary_key: :id,
      foreign_key: "#{name.underscore}_id".to_sym
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
      class_name: name.capitalize.singularize,
      primary_key: :id,
      foreign_key: "#{self_class_name.underscore}_id".to_sym
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

module Associatable

  def belongs_to(name, options = {})

    define_method(name) do
      if options.is_a?(Hash) && options[:foreign_key]
        foreign_id = { foreign_key: options[:foreign_key] }
        options = BelongsToOptions.new(name.to_s, foreign_id)
      elsif options.is_a?(Hash) && options.empty?
        options = BelongsToOptions.new(name.to_s)
      end

      foreign_key = self.send(options.foreign_key)

      model = options.model_class
      model.where(id: foreign_key).first
    end
  end

  def has_many(name, options = {})

    self_class_name = self.to_s
    define_method(name) do
      if options.is_a?(Hash) && options[:foreign_key]
        foreign_id = { foreign_key: options[:foreign_key] }
        options = HasManyOptions.new(name.to_s, self_class_name, foreign_id)
      elsif options.is_a?(Hash) && options.empty?
        options = HasManyOptions.new(name.to_s, self_class_name)
      end
      debugger
      foreign_key = self.send(options.foreign_key)

      model = options.model_class
      model.where(foreign_key: foreign_key).first
    end
  end

  def assoc_options

  end
end

class SQLObject
  # Mixin Associatable here...
  extend Associatable
end
