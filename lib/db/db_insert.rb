# frozen_string_literal: true

require 'pg'
require_relative 'db_connection'

class DBInsert
  def self.row(connection_params, sql_params, table)
    sql_string(sql_params, table)
    conn = DB::Client.new(connection_params)
    conn.execute_params(@sql, @values)
  end

  def self.sql_string(sql_params, table)
    index = 1
    str_fields = String.new
    str_vars = String.new
    @values = []
    sql_params.each do |k, v|
      str_fields.concat(k.to_s).concat(',')
      str_vars.concat('$').concat(index.to_s).concat(',')
      @values << v
      index += 1
    end
    str_fields.chop!
    str_vars.chop!
    @sql = "INSERT INTO #{table} ( #{str_fields}) VALUES (#{str_vars})"
  end
end
