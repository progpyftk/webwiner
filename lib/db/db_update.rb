# frozen_string_literal: true

require_relative 'db_connection'

class DBUpdate
  def self.row(conn_params, sql_params, field, field_value, table)
    string_sql(sql_params, field, field_value, table)
    conn = DB::Client.new(conn_params)
    puts @sql
    result = conn.execute_params(@sql, @values)
    p result
  end

  def self.string_sql(sql_params, field, _field_value, table)
    index = 1
    str_fields = String.new
    str_vars = String.new
    last_value = ''
    @values = []
    sql_params.each do |k, v|
      str_fields.concat(k.to_s).concat(',')
      str_vars.concat('$').concat(index.to_s).concat(',')
      if k.to_s == field
        last_value = v
      else
        @values << v
      end
      index += 1
    end
    @values << last_value
    str_fields.chop!
    str_vars.chop!
    str_cond_var = "$#{index - 1}"
    str_fields = str_fields.sub("#{field},", '')
    str_vars = str_vars[0..-5]
    @sql = "UPDATE #{table} SET (#{str_fields}) = (#{str_vars}) WHERE #{field} = #{str_cond_var}"
  end
end
