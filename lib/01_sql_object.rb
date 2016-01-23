require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    @columns ||= DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    @columns.first.map { |header| header.to_sym }
  end

  def self.finalize!

    columns.each do |column|
      define_method(column.to_s) do
        attributes[column]
      end

      define_method((column.to_s) + "=") do |var|
        attributes[column] = var
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
    all = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        "#{self.table_name}"
    SQL
    self.parse_all(all)
  end

  def self.parse_all(results)
    parsed = []
    results.each do |row|
      parsed << self.new(row)
    end
    parsed
  end

  def self.find(id)
    found = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        "#{self.table_name}"
      WHERE
        id = #{id}
    SQL

    self.parse_all(found).first
  end

  def initialize(params = {})
    params.each do |key, value|
      raise "unknown attribute '#{key}'" unless self.class.columns.include?(key.to_sym)
      send "#{key}=".to_sym, value
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    values = []
    @attributes.each_value { |value| values << value}
    values
  end

  # def insert
  #   col_names = self.class.columns.join(", ")
  #   question_marks_array = ["?"] * self.class.columns.length
  #   question_marks = question_marks_array.join(", ")
  #   debugger
  #   DBConnection.execute(<<-SQL, *self.attribute_values)
  #     INSERT INTO
  #       "#{self.class.table_name}"
  #   SQL
  #
  # end

  def insert
    col_names = self.class.columns[1..-1].join(", ")
    question_marks_array = ["?"] * self.attribute_values.length
    question_marks = question_marks_array.join(", ")

    debugger
    search_string = <<-SQL
      INSERT INTO
        "#{self.class.table_name} (#{col_names})"
      VALUES
        (#{question_marks})
    SQL

    DBConnection.execute(search_string, *self.attribute_values);

  end

  def update
    # ...
  end

  def save
    # ...
  end
end
