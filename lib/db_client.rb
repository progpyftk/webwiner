# frozen_string_literal: true

require 'pg'
require 'date'
module DBClient
  def self.add(hashobj, table, db)
    conn = PG.connect(host: 'localhost', password: 'admin', user: 'postgres', dbname: db)
    str_fields, str_vars, values = prep_to_sql(hashobj, table)
    sql = "INSERT INTO #{table} ( #{str_fields}) VALUES (#{str_vars})"
    begin
      conn.prepare('save', sql) # values must match the same order as sql statement
      conn.exec_prepared('save', values) # this method requires an array as second argument
      conn.close
    rescue StandardError => e # if it alreay exists, we are going to update it
      puts e.message
    end
  end

  def self.exist?(field, value, table, db)
    conn = PG.connect(host: 'localhost', password: 'admin', user: 'postgres', dbname: db)
    sql = "SELECT #{field} FROM #{table} WHERE #{field} = $1"
    values = [value]
    conn.prepare('save', sql)
    result = conn.exec_prepared('save', values)
    result.ntuples.positive?
  end

  def self.update(hashobj, field, table, db)
    conn = PG.connect(host: 'localhost', password: 'admin', user: 'postgres', dbname: db)
    str_cond_var = ''
    str_fields, str_vars, values = prep_to_sql(hashobj, table)
    index = values.length + 1
    str_cond_var = '$' + index.to_s
    # we must remove the 'field' from str_fields , remove one str_vars and the value
    str_fields = str_fields.sub(field + ',', '')
    str_vars = str_vars[0...-4]
    p values
    puts values.length
    sql = "UPDATE #{table} SET (#{str_fields}) = (#{str_vars}) WHERE #{field} = #{str_cond_var}"
    p sql

    conn.prepare('save', sql)
    conn.exec_prepared('save', values)
    conn.close
  end

  def self.prep_to_sql(hashobj, _table)
    values = []
    index = 1
    str_fields = String.new
    str_vars = String.new
    hashobj.each do |k, v|
      str_fields.concat(k.to_s).concat(',')
      str_vars.concat('$').concat(index.to_s).concat(',')
      values << v
      index += 1
    end
    str_fields.chop!
    str_vars.chop!
    [str_fields, str_vars, values]
  end

  def self.add_price_history(site, wine_hash)
    table_name = 'price_history_wine' if site == 'wine'
    table_name = 'price_history_evino' if site == 'evino'
    conn = PG.connect(host: 'localhost', password: 'admin', user: 'postgres', dbname: 'webwiner')
    values = [wine_hash[:global_id], wine_hash[:regular_price], wine_hash[:sale_price], wine_hash[:club_price],
              Date.today]
    sql = "INSERT INTO #{table_name} (global_id, price_regular, price_sale, price_club, date)
    VALUES ( $1, $2, $3, $4, $5 )"
    conn.prepare('save', sql)
    conn.exec_prepared('save', values)
    conn.close
  end

  def self.get_global_ids(table)
    conn = PG.connect(host: 'localhost', password: 'admin', user: 'postgres', dbname: 'webwiner')
    sql = "SELECT global_id FROM #{table}"
    result = conn.exec(sql)
    conn.close
    global_ids = []
    result.each do |global_id|
      global_ids << global_id unless global_ids.include?(global_id)
    end
    p global_ids.map! { |each| each['global_id'] }
  end
end
