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
  # Phase IIIb
  def belongs_to(name, options = {})
    # ...
  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  # Mixin Associatable here...
end
