require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_line = params.map do |key, val|
      "#{key} = ?"
    end.join(" AND ")
    
    query = DBConnection.execute(<<-SQL, *(params.values))
    SELECT
      *
    FROM
      #{self.table_name}
    WHERE
      #{where_line}
    SQL
    self.parse_all(self.symbolized(query))
  end
end

class SQLObject
  extend Searchable
  # Mixin Searchable here...
end
