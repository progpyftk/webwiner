# frozen_string_literal: true

module DBase
  # check if databse exists
  def self.check(dbname)
    conn = PG.connect(host: 'localhost', password: 'admin', user: 'postgres')
    result = conn.exec('SELECT datname FROM pg_database;').map { |row| row.values_at('datname') }
    conn.exec("CREATE DATABASE #{dbname}") unless result.flatten.include?(dbname)
    conn.close
  end

  def self.delete(db_name)
    conn = PG.connect(host: 'localhost', password: 'admin', user: 'postgres', dbname: 'postgres')
    sql = "DROP DATABASE IF EXISTS #{db_name}"
    conn.exec(sql)
    conn.close
  end
end
