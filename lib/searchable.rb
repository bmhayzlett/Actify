require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)

    search_query_array = params.keys.map{ |key| key.to_s + " = ?" }
    search_query = search_query_array.join(" AND ")

    search_string = <<-SQL
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{search_query}
    SQL

    found = DBConnection.execute(search_string, *params.values)
    self.parse_all(found)
  end
end

class SQLObject
  self.extend(Searchable)
end
