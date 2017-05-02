require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'

class SQLObject
  def self.columns
    @columns ||= DBConnection.execute2(<<-SQL).first.map(&:to_sym)
      SELECT *
      FROM #{self.table_name}
    SQL
  end

  def self.finalize!
    self.columns.each do |el|
      define_method(el) do
        attributes[el]
      end
      define_method("#{el}=") do |other|
        attributes[el] = other
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    query = DBConnection.execute(<<-SQL)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
    SQL
    self.parse_all(query)
  end

  def self.parse_all(results)
    parsed = results.map do |el|
      self.new(el)
    end
    parsed
  end

  def self.find(id)
    query = DBConnection.execute(<<-SQL)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
      WHERE
        id = #{id};
    SQL
    self.parse_all(query).first
  end

  def initialize(params = {})
    params.each do |attr_name, attr_value|
      if self.class.columns.include?(attr_name.to_sym)
        self.send("#{attr_name}=", attr_value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map do |column|
      self.send(column)
    end
  end

  def insert
    col_names = self.class.columns.drop(1).join(", ")
    question_marks = (["?"] * (self.class.columns.length - 1)).join(", ")
    insertion = DBConnection.execute(<<-SQL, self.attribute_values.drop(1))
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    set_line = self.class.columns.map { |el| "#{el} = ?" }.join(", ")
    updated = DBConnection.execute(<<-SQL, self.attribute_values, self.id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_line}
      WHERE
        id = ?
    SQL
  end

  def save
    if self.id.nil?
      insert
    else
      update
    end
  end
end
