# frozen_string_literal: true

module DB
  require 'pg'

  class Client
    def initialize(params)
      @params = params
    end

    def execute_sql(sql)
      connect
      @conn.exec(sql)
      @conn.close
    end

    def execute_params(sql, values)
      connect
      @conn.prepare('save', sql)
      result = @conn.exec_prepared('save', values)
      @conn.close
      result
    rescue StandardError => e
      e.message
    end

    private

    def connect
      @conn = PG.connect(host: @params[:host],
                         password: @params[:password],
                         user: @params[:user],
                         dbname: @params[:dbname])
    rescue StandardError => e
      p e
    end
  end

  class Exist
    def self.row(connection_params, field, field_value, table)
      conn = DB::Client.new(connection_params)
      sql = "SELECT #{field} FROM #{table} WHERE #{field} = $1"
      result = conn.execute_params(sql, [field_value])
      result.ntuples.positive?
    end
  end
end
